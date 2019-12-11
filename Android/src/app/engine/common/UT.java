package app.engine.common;

import java.util.LinkedList;
import java.util.List;

import android.util.Log;

public class UT {

	private static final String			kTag	= UT.class.getSimpleName();
	private static final List<Event>	mEvents	= new LinkedList<UT.Event>();

	public static void print() {
		for (Event e : mEvents) {
			Log.i(kTag, e.toString());
		}
	}

	public static void upload() {

	}

	public static class Event {

	}
}
