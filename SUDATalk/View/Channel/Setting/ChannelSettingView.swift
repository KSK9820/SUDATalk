//
//  ChannelSettingView.swift
//  SUDATalk
//
//  Created by 박다현 on 11/15/24.
//

import SwiftUI

struct ChannelSettingView: View {
    @StateObject private var container: Container<ChannelSettingIntent, ChannelSettingModelStateProtocol>
    @State private var isExpanded = false
    @AppStorage("userID") var userID: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                channelSummarySection(container.model.channel.name, description: container.model.channel.description)
                
                membersSection(container.model.channel.channelMembers, isExpanded: $isExpanded)
                
                ChannelSettingButtonsView(isOwner: userID ?? "" == container.model.channel.ownerID)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("채널 설정")
        .onAppear{
            container.intent.viewOnAppear()
        }
    }
    
    private func channelSummarySection(_ name: String, description: String?) -> some View {
        VStack(alignment: .leading) {
            Text(name)
                .textStyle(.title2)
                .padding(.bottom, 5)
            
            if let description = description, !description.isEmpty {
                Text(description)
                    .textStyle(.body)
                    .padding(.bottom, 5)
            }
        }
    }
    
    private func membersSection(_ memebers: [ChannelMemberPresentationModel], isExpanded: Binding<Bool>) -> some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.wrappedValue.toggle()
                }
            }) {
                HStack {
                    Text("맴버(\(memebers.count))")
                        .textStyle(.title2)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    (isExpanded.wrappedValue ? Images.chevronUp : Images.chevronDown)
                }
            }
            
            if isExpanded.wrappedValue {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 20) {
                    ForEach(memebers.indices, id: \.self) { index in
                        let memeber = memebers[index]
                        
                        memberRow(memeber)
                            .task {
                                if let profileUrl = memeber.profileImage {
                                    container.intent.fetchProfileImages(profileUrl, index: index)
                                }
                            }
                    }
                }
            }
        }
    }
    
    private func memberRow(_ member: ChannelMemberPresentationModel) -> some View {
        VStack {
            let profileImage = UIImage(data: member.profileImageData ?? Data())
                .map { Image(uiImage: $0) }
                ?? Image(systemName: "person.circle")
            
            profileImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            
            Text(member.nickname)
                .font(.caption)
                .lineLimit(1)
        }
        .padding(.vertical)
    }
}

extension ChannelSettingView {
    static func build(_ workspaceID: String, channelID: String) -> some View {
        let model = ChannelSettingModel()
        let intent = ChannelSettingIntent(model: model)
        
        model.workspaceID = workspaceID
        model.channelID = channelID
        
        let container = Container(
            intent: intent,
            model: model as ChannelSettingModelStateProtocol,
            modelChangePublisher: model.objectWillChange)
        
        return ChannelSettingView(container: container)
    }
}
