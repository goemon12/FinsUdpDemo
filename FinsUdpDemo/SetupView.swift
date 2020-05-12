//
//  SetupView.swift
//  FinsUdpDemo
//
//  Created by Tadahiro Kato on 2020/05/12.
//  Copyright © 2020 goemon12. All rights reserved.
//

import SwiftUI

struct SetupView: View {
    @Binding var txtHost: String
    @Binding var txtPort: String
    @Binding var txtDstNet: String
    @Binding var txtDstNode: String
    @Binding var txtDstUnit: String
    @Binding var txtSrcNet: String
    @Binding var txtSrcNode: String
    @Binding var txtSrcUnit: String
    
    var body: some View {
        Form {
            Section(header: Text("イーサネット")) {
                inText(lbl: "IPアドレス", txt: $txtHost)
                inText(lbl: "ポートNO", txt: $txtPort)
            }
            Section(header: Text("FINS接続先"), content: {
                inText(lbl: "ネットワーク", txt: $txtDstNet)
                inText(lbl: "ノード", txt: $txtDstNode)
                inText(lbl: "ユニット", txt: $txtDstUnit)
            })
            Section(header: Text("FINS接続元"), content: {
                inText(lbl: "ネットワーク", txt: $txtSrcNet)
                inText(lbl: "ノード", txt: $txtSrcNode)
                inText(lbl: "ユニット", txt: $txtSrcUnit)
            })
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView(txtHost: .constant("192.168.250.1"),
                  txtPort: .constant("9600"),
                  txtDstNet: .constant("0"),
                  txtDstNode: .constant("1"),
                  txtDstUnit: .constant("0"),
                  txtSrcNet: .constant("0"),
                  txtSrcNode: .constant("199"),
                  txtSrcUnit: .constant("0"))
    }
}
