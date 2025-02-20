package com.example.deeds

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.widget.ProgressBar

class MyAppWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context?,
        appWidgetManager: AppWidgetManager?,
        appWidgetIds: IntArray?
    ) {
        appWidgetIds?.forEach { appWidgetId ->
            val views = RemoteViews(context?.packageName, R.layout.my_widget_layout)

            // Update Text Views with Prayer Data (dummy data for now)
            views.setTextViewText(R.id.current_prayer_time, "5:00 AM")
            views.setTextViewText(R.id.current_prayer_label, "Fajr")
            views.setTextViewText(R.id.next_prayer_time, "6:30 AM")
            views.setTextViewText(R.id.next_prayer_label, "Dhuhr")

            // Set the progress dynamically (dummy progress for now)
            val progress = 50 // Example progress value
            views.setProgressBar(R.id.prayer_progress, 100, progress, false)

            // Update the widget with the new data
            appWidgetManager?.updateAppWidget(appWidgetId, views)
        }
    }
}
