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
        sortDescriptors: [SortDescriptor(\Item.timestamp)],
        predicate: NSPredicate(format: "showOnWidget == %d", true)
    )
    private var showOnWidgetItems: FetchedResults<Sounds>*/
    
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
        Text(entry.date, style: .time)
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
