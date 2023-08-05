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
          .font(.system(.title, weight: .bold))
          .foregroundColor(.primary)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.bottom, 15)

          LazyImage(url: detailLaunchViewModel.launch.imageUrlSmall) { state in
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
          .frame(width: 220)
          .padding(.bottom, 15)
          Spacer()
        HStack(alignment: .top, spacing: 15) {
          VStack(alignment: .leading, spacing: 10) {
            Label(detailLaunchViewModel.date, systemImage: "calendar")
              .font(.system(.subheadline, weight: .bold))
              .foregroundColor(.secondary)
              .fixedSize(horizontal: false, vertical: true)

            Label(detailLaunchViewModel.time, systemImage: "clock")
              .font(.system(.subheadline, weight: .bold))
              .foregroundColor(.secondary)
              .padding(.bottom, 5)
              .fixedSize(horizontal: false, vertical: true)
          }
          .frame(width: UIScreen.main.bounds.width * 0.35)
          Spacer()
          VStack(alignment: .leading, spacing: 10) {
            Label(detailLaunchViewModel.flightNumber, systemImage: "number")
              .font(.system(.subheadline, weight: .bold))
              .foregroundColor(.secondary)
              .fixedSize(horizontal: false, vertical: true)
            Label {
              Text(detailLaunchViewModel.launchStatus.textValue.0)
                .font(.system(.subheadline, weight: .bold))
                .foregroundColor(.secondary)
            } icon: {
              Image(systemName: detailLaunchViewModel.launchStatus.textValue.1)
                .font(.system(.subheadline))
                .foregroundColor(detailLaunchViewModel.launchStatus == RocketLaunchStatus.success ?
                  .green : detailLaunchViewModel.launchStatus == RocketLaunchStatus.failure ?
                  .red : .gray)
            }
          } .frame(width: UIScreen.main.bounds.width * 0.35)
        }
      }

      .padding(15)
      .background(
        Rectangle().fill(.ultraThinMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 30))
      )
      .padding(.horizontal, 20)
      .padding(.vertical, 10)
    }
  }


  var detailCard: some View {  Group {
    VStack(spacing: 20) {
      Text(NSLocalizedString("DetailView.Details", comment: "Details subtitle in the detail view"))
        .font(.system(.title, weight: .bold))
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .center)
      Text(detailLaunchViewModel.details )
        .font(.system(.body, weight: .regular))
        .foregroundColor(.secondary)
        .padding(.bottom, 10)
    }
    .padding(15)
    .background(
      Rectangle().fill(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    )
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
  }
  }
}
