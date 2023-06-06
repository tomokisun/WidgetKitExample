import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    let components = DateComponents(minute: 11, second: 14)
    let futureDate = Calendar.current.date(byAdding: components, to: Date())!
    
    return SimpleEntry(date: Date(), startDate: futureDate)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let components = DateComponents(minute: 11, second: 14)
    let futureDate = Calendar.current.date(byAdding: components, to: Date())!
    
    let entry = SimpleEntry(date: Date(), startDate: futureDate)
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      
      let components = DateComponents(minute: 11, second: 14)
      let futureDate = Calendar.current.date(byAdding: components, to: Date())!
      
      let entry = SimpleEntry(date: entryDate, startDate: futureDate)
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let startDate: Date
}

struct WidgetExtensionEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    VStack(alignment: .center, spacing: 4) {
      Text(entry.startDate, style: .relative)
      Text(entry.startDate, style: .offset)
    }
    .multilineTextAlignment(.center)
  }
}

struct WidgetExtension: Widget {
  let kind: String = "WidgetExtension"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      WidgetExtensionEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct WidgetExtension_Previews: PreviewProvider {
  static var previews: some View {
    let components = DateComponents(minute: 11, second: 14)
    let futureDate = Calendar.current.date(byAdding: components, to: Date())!
    
    return WidgetExtensionEntryView(
      entry: SimpleEntry(
        date: Date(),
        startDate: futureDate
      )
    )
    .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
