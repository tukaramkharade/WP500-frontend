package com.tas.wp500.utils;

public class IntervalMapper {

	// getIntervalByString("5 min")
	public static String getIntervalByString(String intervalStr) {
		String[] splitStr = intervalStr.split(" ");
		if (splitStr[1].equalsIgnoreCase("sec")) {
			return splitStr[0] + "";
		} else if (splitStr[1].equalsIgnoreCase("min")) {
			int minInSec = Integer.parseInt(splitStr[0]) * 60;
			return minInSec + "";
		} else if (splitStr[1].equalsIgnoreCase("hour")) {
			int hourInSec = Integer.parseInt(splitStr[0]) * 60 * 60;
			return hourInSec + "";
		}

		return "Invalid interval format";
	}

	// getIntervalByValue(1800)
	public static String getIntervalByValue(int seconds) {
		String intervalString = "";
		
		if (seconds < 60) {
			intervalString = seconds + " sec";
		} else if (seconds < 3600) {
			int minutes = seconds / 60;
			intervalString = minutes + " min";
		} else {
			int hours = seconds / 3600;
			intervalString = hours + " hour";
		}

		return intervalString;
	}
}
