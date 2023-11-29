package com.tas.wp500.utils;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.HashMap;
import java.util.Map;

@WebListener
public class SessionListener implements HttpSessionListener {

    private static Map<String, HttpSession> activeSessions = new HashMap<>();

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Do nothing on session creation
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        String username = (String) session.getAttribute("username");

        if (username != null) {
            // Remove the destroyed session from the activeSessions map
            activeSessions.remove(username);
        }
    }

    public static void invalidateUserSessions(String username) {
        // Invalidate all sessions for a given username
        HttpSession session = activeSessions.get(username);
        if (session != null) {
            session.invalidate();
            activeSessions.remove(username);
        }
    }

    public static void addActiveSession(String username, HttpSession session) {
        // Add a session to the activeSessions map
        activeSessions.put(username, session);
    }
}
