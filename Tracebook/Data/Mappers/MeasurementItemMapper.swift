//
//  MeasurementItemMapper.swift
//  TracebookDB
//
//  Created by Marcus Painter on 30/07/2025.
//

class MeasurementItemMapper {
    
    static func toModel(body: MeasurementBody) -> MeasurementItem {
        
        let model = MeasurementItem(
            id: body.id,
            additionalContent: body.additionalContent ?? "",
            approved: body.approved == "Approved",
            commentCreator: body.commentCreator ?? "",
            productLaunchDateText: body.productLaunchDateText ?? "",
            thumbnailImage: body.thumbnailImage ?? "",
            upvotes: body.upvotes?.joined(separator: ",") ?? "",
            createdDate: DataMapperHelper.parseISODate(body.createdDate),
            createdBy: body.createdBy ?? "",
            modifiedDate: DataMapperHelper.parseISODate(body.modifiedDate),
            slug:  "https://trace-book.org/measurement/\(body.slug ?? "")",
            moderator1: body.moderator1 ?? "",
            isPublic: body.isPublic ?? false,
            title: body.title ?? "",
            publishDate: DataMapperHelper.parseISODate(body.publishDate),
            admin1Approved: body.admin1Approved == "Approved",
            moderator2: body.moderator2 ?? "",
            admin2Approved: body.admin2Approved == "Approved",
            loudspeakerTags: body.loudspeakerTags?.joined(separator: ",") ?? "",
            emailSent: body.emailSent ?? false,
                 
            content: nil
         
        )

        return model
    }
}
