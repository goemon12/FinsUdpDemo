//
//  ContentView.swift
//  FinsUdpDemo
//
//  Created by goemon12 on 2020/04/27.
//  Copyright © 2020 goemon12. All rights reserved.
//

import SwiftUI
import Network

var connection: NWConnection?
var host: NWEndpoint.Host?
var port: NWEndpoint.Port?
var dstn: UInt8?
var srcn: UInt8?
var name: UInt8?
var addr: UInt16?
var leng: UInt16?

struct ContentView: View {
    @State var txtHost = "192.168.250.1"
    @State var txtPort = "9600"
    @State var intChName = 0
    @State var txtChAddr = "0"
    @State var txtChLeng = "1"
    @State var txtView = ""

    func openFINS() {
        host = NWEndpoint.Host(txtHost)
        if (host == nil) {
            txtView += "host error\n"
            return
        }
        
        port = NWEndpoint.Port(rawValue: UInt16(txtPort)!)
        if (port == nil) {
            txtView += "port error\n"
            return
        }
        
        dstn = UInt8(txtHost.components(separatedBy: ".")[3])
        if (dstn == nil) {
            txtView += "dst node error\n"
            return
        }
        
        srcn = UInt8(199)
        if (srcn == nil) {
            txtView += "src node error\n"
            return
        }
        
        let datChName: [UInt8] = [0xb0, 0x82, 0xa0]
        name = datChName[intChName]
        if (name == nil) {
            txtView += "name error\n"
            return
        }
        
        addr = UInt16(txtChAddr)
        if (addr == nil) {
            txtView += "addr error\n"
            return
        }
        
        leng = UInt16(txtChLeng)
        if (leng == nil) {
            txtView += "leng error\n"
            return
        }
        
        connection = NWConnection(host: host!, port: port!, using: .udp)
        if (connection == nil) {
            txtView += "connection error\n"
            return
        }
        
        connection!.stateUpdateHandler = {(state) in
            if (state == .ready) {
                self.txtView  = "準備完了\n\n"
                self.sendFINS()
            }
            else {
                self.txtView += "準備待ち\n\n"
            }
        }
        
        connection!.start(queue: DispatchQueue.main)
    }
    
    func sendFINS() {
        let slen = 18
        var sbuf = [UInt8](repeating: 0x00, count: 20)
        
        sbuf[ 0] = 0x80
        sbuf[ 1] = 0x00
        sbuf[ 2] = 0x02
        sbuf[ 3] = 0x00//DNA
        sbuf[ 4] = dstn!//DA1
        sbuf[ 5] = 0x00//DA2
        sbuf[ 6] = 0x00//SNA
        sbuf[ 7] = srcn!//SA1
        sbuf[ 8] = 0x00//SA2
        sbuf[ 9] = 0x00//SID
        sbuf[10] = 0x01//MRC
        sbuf[11] = 0x01//SRC
        sbuf[12] = name!//CH NAME
        sbuf[13] = UInt8(addr! / 0x100)
        sbuf[14] = UInt8(addr! % 0x100)
        sbuf[15] = 0x00
        sbuf[16] = UInt8(leng! / 0x100)
        sbuf[17] = UInt8(leng! % 0x100)

        var stxt = "送信:"
        for i in 0 ..< slen {
            stxt += String(format: " %02x", sbuf[i])
        }
        stxt += "\n\n"
        
        let sdat = Data(bytes: sbuf, count: slen)
        connection!.send(content: sdat, completion: .contentProcessed({(error) in
            if (error == nil) {
                self.txtView += stxt
                self.recvFINS()
            }
            else {
                self.txtView += "send error\n"
            }
        }))
    }
    
    func recvFINS() {
        connection!.receive(minimumIncompleteLength: 1, maximumLength: 1000, completion: {(rdat, _, _, error) in
            if (error == nil) {
                var rtxt = "受信:"
                for i in 0 ..< rdat!.count {
                    rtxt += String(format: " %02x", [UInt8](rdat!)[i])
                }
                rtxt += "\n\n"
                
                let strChName = ["CIO", "DM", "E0"]
                if (rdat!.count == leng! * 2 + 14) {
                    for i in 0 ..< Int(leng!) {
                        rtxt += strChName[self.intChName]
                        rtxt += String(format: " %04d CH", Int(addr!) + i)
                        rtxt += String(format: " = %02x", [UInt8](rdat!)[14 + i * 2])
                        rtxt += String(format: "%02x HEX\n", [UInt8](rdat!)[15 + i * 2])
                    }
                }
                rtxt += "\n"
                rtxt += "通信終了\n"
                self.txtView += rtxt
            }
            else {
                self.txtView += "recv error\n"
            }
        })
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10.0) {
                inText(lbl: "IPアドレス", txt: $txtHost)
                inText(lbl: "ポートNO", txt: $txtPort)
                inName(lbl: "CH種類", num: $intChName)
                inText(lbl: "CHアドレス", txt: $txtChAddr)
                inText(lbl: "CH数", txt: $txtChLeng)
                ScrollView {
                    Text(txtView)
                        .frame(maxWidth: 1000, alignment: .topLeading)
                        .lineSpacing(5)
                }
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            }
            .font(.custom("Courier", size: 18))
            .padding(.top, 10)
            .navigationBarTitle("Fins/Udpデモ", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.openFINS()
            }) {
                Text("送信")
            })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
