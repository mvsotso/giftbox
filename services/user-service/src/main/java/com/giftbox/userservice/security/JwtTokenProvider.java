package com.giftbox.userservice.security;

import com.giftbox.userservice.model.User;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * JWT Token Provider
 * 
 * Handles JWT token generation, validation, and parsing.
 */
@Component
public class JwtTokenProvider {

    private static final Logger logger = LoggerFactory.getLogger(JwtTokenProvider.class);

    @Value("${jwt.secret:giftbox-secret-key-that-should-be-changed-in-production}")
    private String jwtSecret;

    @Value("${jwt.access-token-validity:3600}")
    private int accessTokenValidityInSeconds;

    @Value("${jwt.refresh-token-validity:86400}")
    private int refreshTokenValidityInSeconds;

    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    /**
     * Generate access token
     */
    public String generateAccessToken(User user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", user.getId().toString());
        claims.put("email", user.getEmail());
        claims.put("firstName", user.getFirstName());
        claims.put("lastName", user.getLastName());
        claims.put("isVerified", user.getIsVerified());
        claims.put("tokenType", "access");

        return createToken(claims, user.getEmail(), accessTokenValidityInSeconds);
    }

    /**
     * Generate refresh token
     */
    public String generateRefreshToken(User user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", user.getId().toString());
        claims.put("email", user.getEmail());
        claims.put("tokenType", "refresh");

        return createToken(claims, user.getEmail(), refreshTokenValidityInSeconds);
    }

    /**
     * Create JWT token
     */
    private String createToken(Map<String, Object> claims, String subject, int validityInSeconds) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + validityInSeconds * 1000L);

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(getSigningKey(), SignatureAlgorithm.HS512)
                .compact();
    }

    /**
     * Validate JWT token
     */
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (SecurityException ex) {
            logger.error("Invalid JWT signature");
        } catch (MalformedJwtException ex) {
            logger.error("Invalid JWT token");
        } catch (ExpiredJwtException ex) {
            logger.error("Expired JWT token");
        } catch (UnsupportedJwtException ex) {
            logger.error("Unsupported JWT token");
        } catch (IllegalArgumentException ex) {
            logger.error("JWT claims string is empty");
        }
        return false;
    }

    /**
     * Get user ID from token
     */
    public String getUserIdFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.get("userId", String.class);
    }

    /**
     * Get email from token
     */
    public String getEmailFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.getSubject();
    }

    /**
     * Get claims from token
     */
    private Claims getClaimsFromToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    /**
     * Check if token is expired
     */
    public boolean isTokenExpired(String token) {
        try {
            Claims claims = getClaimsFromToken(token);
            return claims.getExpiration().before(new Date());
        } catch (Exception e) {
            return true;
        }
    }

    /**
     * Get token expiration date
     */
    public Date getTokenExpirationDate(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.getExpiration();
    }

    /**
     * Get token type from token
     */
    public String getTokenTypeFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.get("tokenType", String.class);
    }

    /**
     * Check if token is access token
     */
    public boolean isAccessToken(String token) {
        String tokenType = getTokenTypeFromToken(token);
        return "access".equals(tokenType);
    }

    /**
     * Check if token is refresh token
     */
    public boolean isRefreshToken(String token) {
        String tokenType = getTokenTypeFromToken(token);
        return "refresh".equals(tokenType);
    }

    /**
     * Invalidate token (for logout)
     */
    public void invalidateToken(String token) {
        // In a real implementation, you might want to add the token to a blacklist
        // For now, we'll just log the invalidation
        logger.info("Token invalidated: {}", token.substring(0, Math.min(token.length(), 20)) + "...");
    }

    /**
     * Get access token validity in seconds
     */
    public int getAccessTokenValidityInSeconds() {
        return accessTokenValidityInSeconds;
    }

    /**
     * Get refresh token validity in seconds
     */
    public int getRefreshTokenValidityInSeconds() {
        return refreshTokenValidityInSeconds;
    }
}
