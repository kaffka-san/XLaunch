//
//  DetailView.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 02.08.2023.
//

import SwiftUI

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
  var launchCard: some View {
    Group {
      VStack {
        Text(detailLaunchViewModel.launch.name )
          .font(.system(.largeTitle, weight: .bold))
          .foregroundColor(.primary)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.bottom, 15)
        HStack(spacing: 10) {
          AsyncImage(url: URL(string: detailLaunchViewModel.launch.links?.patch?.large ?? "")) { image in
            image
              .resizable()
          } placeholder: {
            ProgressView()
          }
          .scaledToFit()
          .frame(width: 120)
          Spacer()
          VStack(alignment: .leading, spacing: 15) {
            Text("Launch date:")
              .font(.system(.title2, weight: .bold))
              .foregroundColor(.primary)
              .frame(maxWidth: .infinity, alignment: .leading)

            Text("\(detailLaunchViewModel.date)")
              .font(.system(.title3, weight: .bold))
              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.bottom, 5)

            Text("Launch Status:")
              .font(.system(.title2, weight: .bold))
              .foregroundColor(.primary)

            Label {
              Text(detailLaunchViewModel.launchStatus.rawValue.0)
                .font(.system(.title3, weight: .bold))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            } icon: {
              Image(systemName: detailLaunchViewModel.launchStatus.rawValue.1)
                .font(.system(.title3))
                .foregroundColor(detailLaunchViewModel.launchStatus == RocketLaunchStatus.success ? .green : detailLaunchViewModel.launchStatus == RocketLaunchStatus.failure ? .red : .gray)
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
      Text("Details:")
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
