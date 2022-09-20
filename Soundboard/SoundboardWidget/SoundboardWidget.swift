//
//  SoundboardWidget.swift
//  SoundboardWidget
//
//  Created by Fabian Kuschke on 20.09.22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct SoundboardWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    @Environment(\.managedObjectContext) private var viewContext
    
    /*
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\Sounds.showOnLS)],
        predicate: NSPredicate(format: "showOnLS == %d", true)
    )*/
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Sounds.soundName, ascending: true)],
        animation: .default)
    
    private var showOnWidgetItems: FetchedResults<Sounds>
    
    var fontStyle : Font {
        switch widgetFamily {
        case .accessoryCircular:
            return .system(.footnote, design: .rounded)
        case .systemSmall:
            return .system(.footnote, design: .rounded)
        case .systemMedium:
            return .system(.headline, design: .rounded)
        case .systemLarge:
            return .system(.headline, design: .rounded)
        case .systemExtraLarge:
            return .system(.headline, design: .rounded)
        case .accessoryRectangular:
            return .system(.footnote, design: .rounded)
        case .accessoryInline:
            return .system(.footnote, design: .rounded)
        @unknown default:
            return .system(.headline, design: .rounded)
        }
    }

    var body: some View {
        //Text(entry.date, style: .time)
        switch
        if showOnWidgetItems.count > 0 {
            Text(showOnWidgetItems[0].soundName ?? "")
                .font(fontStyle)
                .fontWeight(.medium)
                .foregroundColor(showOnWidgetItems[0].showOnLS ? Color.green : Color.red)
                .padding(.vertical, 10)
                .lineLimit(3)
            Divider()
        }
        if showOnWidgetItems.count > 1 {
            Text(showOnWidgetItems[1].soundName ?? "")
                .font(fontStyle)
                .fontWeight(.medium)
                .foregroundColor(showOnWidgetItems[1].showOnLS ? Color.green : Color.red)
                .padding(.vertical, 10)
                .lineLimit(3)
            Divider()
        }
        if showOnWidgetItems.count > 2 {
            Text(showOnWidgetItems[2].soundName ?? "")
            .font(fontStyle)
            .fontWeight(.medium)
            .foregroundColor(showOnWidgetItems[2].showOnLS ? Color.green : Color.red)
            .padding(.vertical, 10)
            .lineLimit(3)
    }
    }
}

@main
struct SoundboardWidget: Widget {
    let kind: String = "SoundboardWidget"
    var persistenceController = PersistenceController.shared

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SoundboardWidgetEntryView(entry: entry)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        //.supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular]) //LS support
    }
}

struct SoundboardWidget_Previews: PreviewProvider {
    static var previews: some View {
        SoundboardWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
