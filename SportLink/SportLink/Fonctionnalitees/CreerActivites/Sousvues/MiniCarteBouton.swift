//
//  MiniCarteBouton.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-04.
//

import SwiftUI
import MapKit

struct MiniCarteBouton: View {
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    
    @State private var montrerCarte = false
    @State var location: CLLocation? = {
        if let coord = UserDefaults.standard.dernierePosition {
            return CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        }
        return nil
    }()

    @Binding var sportChoisis: Set<String>
    @Binding var infraChoisie: Infrastructure?

    var body: some View {
        Button {
            montrerCarte = true
        } label: {
            MapSnapshotVue(location: location, infraChoisie: infraChoisie)
        }
        .sheet(isPresented: $montrerCarte) {
            NavigationView {
                VStack(spacing: 16) {
                    Text("Select a marker")
                        .font(.headline)
                        .padding(.top, 40)

                    Divider()

                    CarteCreationActivite(
                        sportChoisis: $sportChoisis,
                        infraChoisie: $infraChoisie
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.horizontal)


                    Spacer()

                    Button {
                        montrerCarte = false
                    } label: {
                        Text("Close")
                            .padding(.horizontal, 20)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("CouleurParDefaut"))
                        
                }
                .background(.ultraThinMaterial)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(20)
        }
    }
}

struct MapSnapshotVue: View {
    @State private var imageSnapshot: UIImage?
    
    let location: CLLocation?
    let infraChoisie: Infrastructure?
    
    var body: some View {
        Group {
            if let image = imageSnapshot {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ProgressView()
                    .frame(height: 150)
            }
        }
        .onAppear(perform: genererSnapshot)
        .onChange(of: infraChoisie?.id) {
            imageSnapshot = nil
            genererSnapshot()
        }
    }
    
    private func genererSnapshot() {
        let options = MKMapSnapshotter.Options()
        let centreCoords = infraChoisie?.coordonnees ??
            location?.coordinate ??
            CLLocationCoordinate2D(latitude: 45.4215, longitude: -75.6972) // Ottawa
        options.region = MKCoordinateRegion(
            center: centreCoords,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125)
        )
        options.size = CGSize(width: 300, height: 150)
        options.scale = UIScreen.main.scale
        options.pointOfInterestFilter = .excludingAll
    

        MKMapSnapshotter(options: options).start { snapshot, error in
            guard let snapshot = snapshot, error == nil else { return }
            var image = snapshot.image

            if let infra = infraChoisie {
                let pinPoint = snapshot.point(for: infra.coordonnees)
                UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
                image.draw(at: .zero)

                // Icône système ou image personnalisée
                let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
                let pinImage = UIImage(
                    systemName: "mappin.circle.fill",
                    withConfiguration: config
                )?
                .withTintColor(.red, renderingMode: .alwaysOriginal)
                
                if let pin = pinImage {
                    let drawPoint = CGPoint(
                        x: pinPoint.x - pin.size.width / 2,
                        y: pinPoint.y - pin.size.height
                    )
                    pin.draw(at: drawPoint)
                }

                if let composed = UIGraphicsGetImageFromCurrentImageContext() {
                    image = composed
                }
                UIGraphicsEndImageContext()
            }
            imageSnapshot = image
        }
    }
}

#Preview {
    MiniCarteBouton(sportChoisis: .constant(["All"]), infraChoisie: .constant(nil))
        .environmentObject(DonneesEmplacementService())
}
