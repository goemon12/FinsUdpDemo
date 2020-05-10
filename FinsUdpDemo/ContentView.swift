import SwiftUI

struct ContentView: View {
    @ObservedObject var fins = FINS()
    
    @State var txtHost = "192.168.250.1"
    @State var txtPort = "9600"
    @State var intChName = 0
    @State var txtChAddr = "0"
    @State var txtChLeng = "1"

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10.0) {
                inText(lbl: "IPアドレス", txt: $txtHost)
                inText(lbl: "ポートNO", txt: $txtPort)
                inName(lbl: "CH種類", num: $intChName)
                inText(lbl: "CHアドレス", txt: $txtChAddr)
                inText(lbl: "CH数", txt: $txtChLeng)
                ScrollView {
                    Text(self.fins.txtView)
                        .padding(.all, 5)
                        .frame(maxWidth: 1000, alignment: .topLeading)
                        .lineSpacing(5)
                }
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            }
            .font(.custom("Courier", size: 18))
            .padding(.top, 10)
            .navigationBarTitle("Fins/Udpデモ", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                let tmp1 = self.fins.open(txtHost: self.txtHost, txtPort: self.txtPort,
                               intChName: self.intChName, txtChAddr: self.txtChAddr, txtChLeng: self.txtChLeng)
                if (tmp1 != true) {
                    self.fins.txtView += "Error\n"
                }
            }) {
                Text("Fins送信")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
