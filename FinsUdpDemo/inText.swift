//
//  inText.swift
//  FinsUdpDemo
//
//  Created by goemon12 on 2020/04/27.
//  Copyright © 2020 goemon12. All rights reserved.
//

import SwiftUI

struct inText: View {
    var lbl: String
    @Binding var txt: String
    
    var body: some View {
        HStack {
            Text(lbl)
                .padding(.all, 5)
                .frame(width: 120, height: 40, alignment: .bottomLeading)

            TextField("", text: $txt)
                .keyboardType(.numbersAndPunctuation)
                .padding(.all, 5)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct inText_Previews: PreviewProvider {
    static var previews: some View {
        inText(lbl: "TEST", txt: .constant("192.168.250.1"))
    }
}
