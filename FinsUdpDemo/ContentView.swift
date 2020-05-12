import SwiftUI

struct ContentView: View {
    @ObservedObject var fins = FINS()
    
    @State var txtHost = "192.168.250.1"
    @State var txtPort = "9600"

    @State var txtDstNet  = "0"
    @State var txtDstNode = "1"
    @State var txtDstUnit = "0"

    @State var txtSrcNet  = "0"
    @State var txtSrcNode = "199"
    @State var txtSrcUnit = "0"
    
    @State var intChName = 0
    @State var txtChAddr = "0"
    @State var txtChLeng = "1"

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                HStack {
                    Text("イーサネット")
                        .padding(.all, 5)
                        .frame(width: 120, alignment: .bottomLeading)
                    Text(txtHost + "/" + txtPort)
                        .frame(maxWidth: 1000, alignment: .bottomLeading)
                }
                .background(Color(red: 0.8, green: 0.8, blue: 1.0))
                    
                HStack {
                    Text("FINS接続先")
                        .padding(.all, 5)
                        .frame(width: 120, alignment: .bottomLeading)
                    Text(txtDstNet)
                        .frame(width: 50, alignment: .bottomTrailing)
                    Text(txtDstNode)
                        .frame(width: 50, alignment: .bottomTrailing)
                    Text(txtDstUnit)
                        .frame(width: 50, alignment: .bottomTrailing)
                    Spacer()
                }
                .background(Color(red: 0.8, green: 0.8, blue: 1.0))

                HStack {
                    Text("FINS接続元")
                        .padding(.all, 5)
                        .frame(width: 120, alignment: .bottomLeading)
                    Text(txtSrcNet)
                        .frame(width: 50, alignment: .bottomTrailing)
                    Text(txtSrcNode)
                        .frame(width: 50, alignment: .bottomTrailing)
                    Text(txtSrcUnit)
                        .frame(width: 50, alignment: .bottomTrailing)
                    Spacer()
                }
                .background(Color(red: 0.8, green: 0.8, blue: 1.0))

                ScrollView {
                    Text(self.fins.txtView)
                        .frame(maxWidth: 1000, alignment: .topLeading)
                        .lineSpacing(5)
                }
                .padding(.all, 5)
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                
                Button(action: {
                    if (self.fins.open(txtHost: self.txtHost, txtPort: self.txtPort, txtDstNet: self.txtDstNet, txtDstNode: self.txtDstNode, txtDstUnit: self.txtDstUnit, txtSrcNet: self.txtSrcNet, txtSrcNode: self.txtSrcNode, txtSrcUnit: self.txtSrcUnit) == true) {
                    }
                    else {
                        self.fins.txtView += "ERROR\n"
                    }
                }, label: {
                    Text("コマンド0501を送信する")
                })
                .padding()
                .frame(maxWidth: 1000)
                .background(Color(red: 0.7, green: 0.9, blue: 0.7))
            }
            .font(.custom("Courier", size: 18))
            .padding()
                
            .navigationBarTitle("Fins/Udpデモ", displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(
                    destination: SetupView(txtHost: $txtHost, txtPort: $txtPort, txtDstNet: $txtDstNet, txtDstNode: $txtDstNode, txtDstUnit: $txtDstUnit, txtSrcNet: $txtSrcNet, txtSrcNode: $txtSrcNode, txtSrcUnit: $txtSrcUnit), label: {
                    Text("接続の設定")
                })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
