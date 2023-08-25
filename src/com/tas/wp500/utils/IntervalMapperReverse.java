package com.tas.wp500.utils;

import java.util.HashMap;
import java.util.Map;

public class IntervalMapperReverse {

	private static Map<String, String> reverseIntervalMap = new HashMap<>();

    static {
        reverseIntervalMap.put("5", "5 sec");
        reverseIntervalMap.put("10", "10 sec");
        reverseIntervalMap.put("15", "15 sec");
		reverseIntervalMap.put("20", "20 sec");
		reverseIntervalMap.put("25", "25 sec");
		reverseIntervalMap.put("30", "30 sec");
		reverseIntervalMap.put("60", "1 min");
		reverseIntervalMap.put("300", "5 min");
		reverseIntervalMap.put("600", "10 min");
		reverseIntervalMap.put("900", "15 min");
		reverseIntervalMap.put("1200", "20 min");
		reverseIntervalMap.put("1500", "25 min");
		reverseIntervalMap.put("1800", "30 min");
		reverseIntervalMap.put("3600", "1 hour");
    }
    
    public static String getIntervalString(String interval) {
        String intervalString = reverseIntervalMap.get(interval);
        return intervalString != null ? intervalString : "Unknown Interval";
    }
}
