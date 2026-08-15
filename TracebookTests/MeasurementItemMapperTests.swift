import Testing
@testable import Tracebook

@Suite
@MainActor
struct MeasurementItemMapperTests {
    @Test
    func updatePreservesContentWhenReferenceIsUnchanged() {
        let item = MeasurementItem(id: "measurement", additionalContent: "content-1")
        let content = MeasurementContent(id: "content-1", dspPreset: "Original")
        item.content = content

        let body = MeasurementBody()
        body.id = item.id
        body.additionalContent = "content-1"
        body.title = "Updated title"

        MeasurementItemMapper.update(model: item, from: body)

        #expect(item.content === content)
        #expect(item.title == "Updated title")
    }

    @Test
    func updateClearsContentWhenReferenceChanges() {
        let item = MeasurementItem(id: "measurement", additionalContent: "content-1")
        item.content = MeasurementContent(id: "content-1")

        let body = MeasurementBody()
        body.id = item.id
        body.additionalContent = "content-2"

        MeasurementItemMapper.update(model: item, from: body)

        #expect(item.additionalContent == "content-2")
        #expect(item.content == nil)
    }
}
