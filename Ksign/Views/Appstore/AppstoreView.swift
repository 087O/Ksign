//
//  AppstoreView.swift
//  Ksign
//
//  Created by Nagata Asami on 3/8/25.
//

import SwiftUI
import CoreData
import AltSourceKit

struct AppstoreView: View {
	@StateObject private var _viewModel = SourcesViewModel.shared
	
	@FetchRequest(
		entity: AltSource.entity(),
		sortDescriptors: [NSSortDescriptor(keyPath: \AltSource.name, ascending: true)],
		animation: .snappy
	) private var _sources: FetchedResults<AltSource>
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 20) {
					// Header Section
					VStack(alignment: .leading, spacing: 8) {
						Text("Swift Store")
							.font(.system(size: 32, weight: .bold, design: .default))
							.foregroundStyle(.primary)
						
						Text("Browse and discover apps from curated sources")
							.font(.subheadline)
							.foregroundStyle(.secondary)
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal, 16)
					.padding(.top, 8)
					
					// Featured Section
					if !_sources.isEmpty {
						VStack(alignment: .leading, spacing: 12) {
							Text("Featured")
								.font(.headline)
								.padding(.horizontal, 16)
							
							ScrollView(.horizontal, showsIndicators: false) {
								HStack(spacing: 12) {
									ForEach(Array(_sources.prefix(3)), id: \.self) { source in
										FeatureCardView(source: source)
									}
								}
								.padding(.horizontal, 16)
							}
						}
					}
					
					// Categories Section
					VStack(alignment: .leading, spacing: 12) {
						Text("Categories")
							.font(.headline)
							.padding(.horizontal, 16)
						
						VStack(spacing: 10) {
							NavigationLink(destination: SourceAppsView(fromAppStore: true, object: Array(_sources), viewModel: _viewModel)) {
								HStack {
									VStack(alignment: .leading, spacing: 4) {
										Text("All Apps")
											.font(.headline)
											.foregroundStyle(.primary)
										Text("Browse all available applications")
											.font(.caption)
											.foregroundStyle(.secondary)
									}
									Spacer()
									Image(systemName: "chevron.right")
										.foregroundStyle(.secondary)
								}
								.padding(16)
								.background(Color(uiColor: .secondarySystemBackground))
								.cornerRadius(12)
							}
							
							ForEach(Array(_sources.prefix(5)), id: \.self) { source in
								NavigationLink(destination: SourceAppsView(fromAppStore: true, object: [source], viewModel: _viewModel)) {
									HStack {
										VStack(alignment: .leading, spacing: 4) {
											Text(source.name ?? "Unknown Source")
												.font(.headline)
												.foregroundStyle(.primary)
												.lineLimit(1)
											if let appCount = source.apps?.count {
												Text("\(appCount) apps")
													.font(.caption)
													.foregroundStyle(.secondary)
											}
										}
										Spacer()
										Image(systemName: "chevron.right")
											.foregroundStyle(.secondary)
									}
									.padding(16)
									.background(Color(uiColor: .secondarySystemBackground))
									.cornerRadius(12)
								}
							}
						}
						.padding(.horizontal, 16)
					}
					
					// Info Section
					VStack(alignment: .leading, spacing: 12) {
						Text("About Swift Store")
							.font(.headline)
							.padding(.horizontal, 16)
						
						VStack(alignment: .leading, spacing: 16) {
							HStack(spacing: 12) {
								Image(systemName: "star.fill")
									.font(.headline)
									.foregroundStyle(.accent)
									.frame(width: 24)
								
								VStack(alignment: .leading, spacing: 2) {
									Text("Curated Collections")
										.font(.subheadline)
										.fontWeight(.semibold)
									Text("Access apps from multiple verified sources")
										.font(.caption)
										.foregroundStyle(.secondary)
								}
							}
							
							HStack(spacing: 12) {
								Image(systemName: "bolt.fill")
									.font(.headline)
									.foregroundStyle(.accent)
									.frame(width: 24)
								
								VStack(alignment: .leading, spacing: 2) {
									Text("Fast Installation")
										.font(.subheadline)
										.fontWeight(.semibold)
									Text("Quick and reliable app installation")
										.font(.caption)
										.foregroundStyle(.secondary)
								}
							}
							
							HStack(spacing: 12) {
								Image(systemName: "shield.fill")
									.font(.headline)
									.foregroundStyle(.accent)
									.frame(width: 24)
								
								VStack(alignment: .leading, spacing: 2) {
									Text("Secure Signing")
										.font(.subheadline)
										.fontWeight(.semibold)
									Text("Enterprise-grade app signing capabilities")
										.font(.caption)
										.foregroundStyle(.secondary)
								}
							}
						}
						.padding(16)
						.background(Color(uiColor: .secondarySystemBackground))
						.cornerRadius(12)
						.padding(.horizontal, 16)
					}
					
					Spacer(minLength: 20)
				}
				.padding(.vertical, 8)
			}
			.navigationTitle("App Store")
			.navigationBarTitleDisplayMode(.inline)
			.task(id: Array(_sources)) {
				await _viewModel.fetchSources(_sources)
			}
		}
	}
}

// MARK: - Feature Card View
struct FeatureCardView: View {
	let source: AltSource
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			RoundedRectangle(cornerRadius: 12)
				.fill(LinearGradient(gradient: Gradient(colors: [Color.accent.opacity(0.3), Color.accent.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))
				.frame(height: 120)
				.overlay(
					VStack {
						HStack {
							Image(systemName: "apps.iphone")
								.font(.title2)
								.foregroundStyle(.accent)
							Spacer()
						}
						Spacer()
					}
					.padding(12)
				)
			
			VStack(alignment: .leading, spacing: 4) {
				Text(source.name ?? "Featured Source")
					.font(.headline)
					.lineLimit(2)
					.foregroundStyle(.primary)
				
				if let appCount = source.apps?.count {
					Text("\(appCount) apps")
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
			
			Spacer()
		}
		.frame(width: 160, height: 200)
		.padding(12)
		.background(Color(uiColor: .secondarySystemBackground))
		.cornerRadius(16)
	}
}

#Preview {
	AppstoreView()
}
