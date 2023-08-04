//
//  DetailView.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 02.08.2023.
//

import SwiftUI
import NukeUI

struct DetailView: View {
  var detailLaunchViewModel: DetailLaunchViewModel
  var body: some View {
    ScrollView {
      launchCard
      if !detailLaunchViewModel.details.isEmpty {
        detailCard
      }
    }
  }
  @MainActor var launchCard: some View {
    Group {
      VStack {
        Text(detailLaunchViewModel.launch.name )
          .font(.system(.largeTitle, weight: .bold))
          .foregroundColor(.primary)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.bottom, 15)
        HStack(spacing: 10) {
          LazyImage(url: detailLaunchViewModel.launch.imageUrlLarge) { state in
            if let image = state.image {
              image
                .resizable()
            } else if state.error != nil {
              Image("image-placeholder")
                .resizable()
            } else {
              ProgressView()
            }
          }
          .scaledToFit()
          .frame(width: 120)
          Spacer()
          VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString(
              "DetailView.LaunchDate.Subtitle",
              comment: "Launch date subtitle in the detail view"))
              .font(.system(.title2, weight: .bold))
              .foregroundColor(.primary)
              .frame(maxWidth: .infinity, alignment: .leading)

            Text("\(detailLaunchViewModel.date)")
              .font(.system(.title3, weight: .bold))
              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.bottom, 5)

            Text(NSLocalizedString(
              "DetailView.LaunchStatus.Subtitle",
              comment: "Launch status subtitle in the detail view"))
              .font(.system(.title2, weight: .bold))
              .foregroundColor(.primary)

            Label {
              Text(detailLaunchViewModel.launchStatus.textValue.0)
                .font(.system(.title3, weight: .bold))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            } icon: {
              Image(systemName: detailLaunchViewModel.launchStatus.textValue.1)
                .font(.system(.title3))
                .foregroundColor(detailLaunchViewModel.launchStatus == RocketLaunchStatus.success ?
                  .green : detailLaunchViewModel.launchStatus == RocketLaunchStatus.failure ?
                  .red : .gray)
            }
          }
        }
        .padding(.bottom, 10)
      }

      .padding(20)
      .background(
        Rectangle().fill(.ultraThinMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 30))
      )
      .padding(.horizontal, 15)
      .padding(.vertical, 10)
    }
  }

  var detailCard: some View {  Group {
    VStack(spacing: 20) {
      Text(NSLocalizedString("DetailView.Details", comment: "Details subtitle in the detail view"))
        .font(.system(.title2, weight: .bold))
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
      Text(detailLaunchViewModel.details )
        .font(.system(.body, weight: .regular))
        .foregroundColor(.secondary)
        .padding(.bottom, 10)
    }
    .padding(20)
    .background(
      Rectangle().fill(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    )
    .padding(.horizontal, 15)
    .padding(.vertical, 10)
  }
  }
}
