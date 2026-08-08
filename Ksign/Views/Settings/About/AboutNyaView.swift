//
//  AboutNyaView.swift
//  Ksign
//
//  Created by Nagata Asami on 23/5/25.
//

import SwiftUI
import NimbleViews
import NimbleJSON

// MARK: - View
struct AboutNyaView: View {
	private let _dataService = NBFetchService()
	
	@State private var shouldShowPatchNotes = false
	
	// MARK: Body
	var body: some View {
		NBList(.localized("About")) {
            Section {
                VStack {
                    Image(uiImage: (UIImage(named: Bundle.main.iconFileName ?? ""))! )
                        .appIconStyle(size: 72)
                    
                    Text(Bundle.main.exec)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.accent)
                    
                    HStack(spacing: 4) {
                        Text("Version")
                        Text(Bundle.main.version)
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    
                    Button {
                        _showPatchNotes()
                    } label: {
                        Text("Show patch notes").bg()
                    }
                    .font(.footnote)
                    .padding(.top, 4)
                    .tint(.accent)
                }
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(EmptyView())
			
			NBSection(.localized("Credits")) {
				_credit(name: "Abdulbasit Khudair", desc: "Developer", github: "087e", icon: "globe")
			}
			
			NBSection(.localized("Connect")) {
				Button(action: { UIApplication.open("https://github.com/087e") }) {
					HStack {
						Image(systemName: "link.circle.fill")
							.foregroundStyle(.accent)
						Text("GitHub: 087e")
						Spacer()
						Image(systemName: "arrow.up.right")
							.foregroundStyle(.secondary)
					}
				}
				.foregroundStyle(.primary)
				
				Button(action: { UIApplication.open("https://t.me/ipafilesfor") }) {
					HStack {
						Image(systemName: "paperplane.fill")
							.foregroundStyle(.accent)
						Text("Telegram Channel")
						Spacer()
						Image(systemName: "arrow.up.right")
							.foregroundStyle(.secondary)
					}
				}
				.foregroundStyle(.primary)
				
				Button(action: { UIApplication.open("https://www.tiktok.com/@087.n") }) {
					HStack {
						Image(systemName: "music.note")
							.foregroundStyle(.accent)
						Text("TikTok Profile")
						Spacer()
						Image(systemName: "arrow.up.right")
							.foregroundStyle(.secondary)
					}
				}
				.foregroundStyle(.primary)
			}
			
			NBSection("Special thanks!") {
				Group {
					Text(.localized("This couldn't have been done without the original Feather devs! ❤️"))
						.foregroundStyle(.secondary)
						.padding(.vertical, 2)
				}
				.transition(.slide)
			}
            
            NBSection("Acknowledgements") {
                NavigationLink(destination: AboutView()) {
                    HStack {
                        Text("About the original Feather")
                        Spacer()
                    }
                }
            } footer: {
                Text(Bundle.main.bundleIdentifier ?? "")
            }
		}
		.onAppear {
			// Show patch notes when navigating to this view if they haven't been shown before
			if !UserDefaults.standard.bool(forKey: "patchNotesShown") {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					_showPatchNotes()
					UserDefaults.standard.set(true, forKey: "patchNotesShown")
				}
			}
		}
	}
	
	private func _showPatchNotes() {
		UIAlertController.showAlertWithOk(
			title: .localized("From Swift Store, Version \(Bundle.main.version)"),
			message: .localized("This version introduces:\n\n- Optimization for iOS 26\n- Bulk installation support for multiple apps\n- idevice installation method\n- Custom injection path & support for advanced features"),
			isCancel: true,
			thankYou: true
		)
	}
}

// MARK: - Extension: view
extension AboutNyaView {
	@ViewBuilder
	private func _credit(
		name: String?,
		desc: String?,
		github: String,
		icon: String = "person.circle.fill"
	) -> some View {
		FRIconCellView(
			title: name ?? github,
			subtitle: desc ?? "",
			iconUrl: URL(string: "https://github.com/\(github).png")!,
			trailing: AnyView(
				Image(systemName: "arrow.up.right")
					.foregroundStyle(.secondary)
			)
		)
		.onTapGesture {
			if let url = URL(string: "https://github.com/\(github)") {
				UIApplication.shared.open(url)
			}
		}
	}
}
