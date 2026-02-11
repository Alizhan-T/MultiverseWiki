import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.top, 50)
            
            Text(Auth.auth().currentUser?.email ?? "No Email")
                .font(.title2)
                .bold()
            
            Spacer()
            
            Button(action: signOut) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false        
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
