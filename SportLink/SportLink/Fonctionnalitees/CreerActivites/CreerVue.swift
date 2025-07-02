import SwiftUI

struct CreerVue: View {
    @Environment(\.dismiss) var dismiss

    @State private var selectedSport: Sport = .soccer
    @State private var showSportOverlay = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer().frame(height: 8)

                // ✅ Bloc Sport clickable
                Button {
                    showSportOverlay = true
                } label: {
                    RectangleVue(showChevron: true) {
                        Image(systemName: selectedSport.icone)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)

                        Text(selectedSport.nom.capitalized)
                            .foregroundColor(.red)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
            }
            .navigationTitle("Create an activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(.systemGray6), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
            .overlay(
                CustomOverlay(isPresented: $showSportOverlay) {
                    VStack(spacing: 16) {
                        Text("Choisir un sport")
                            .font(.headline)

                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(Sport.allCases, id: \.self) { sport in
                                    Button {
                                        selectedSport = sport
                                        showSportOverlay = false
                                    } label: {
                                        HStack {
                                            Image(systemName: sport.icone)
                                                .foregroundColor(.red)
                                            Text(sport.nom.capitalized)
                                                .foregroundColor(.red)
                                            Spacer()
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }

                        Button("Fermer") {
                            showSportOverlay = false
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                }
            )
        }
    }
}



#Preview {
    CreerVue()
}
