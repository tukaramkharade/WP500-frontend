package com.tas.wp500.utils;

import java.util.HashMap;
import java.util.Map;

public class IntervalMapper {
    private static Map<String, String> intervalMap = new HashMap<>();

    static {
        intervalMap.put("5 sec", "5");
        intervalMap.put("10 sec", "10");
        intervalMap.put("15 sec", "15");
		intervalMap.put("20 sec", "20");
		intervalMap.put("25 sec", "25");
		intervalMap.put("30 sec", "30");
		intervalMap.put("1 min", "60");
		intervalMap.put("5 min", "300");
		intervalMap.put("10 min", "600");
		intervalMap.put("15 min", "900");
		intervalMap.put("20 min", "1200");
		intervalMap.put("25 min", "1500");
		intervalMap.put("30 min", "1800");
		intervalMap.put("1 hour", "3600");
    }
    
    public static String getIntervalValue(String intervalString) {
        String intervalValue = intervalMap.get(intervalString);
        return intervalValue != null ? intervalValue : "Unknown Interval Value";
    }
}
