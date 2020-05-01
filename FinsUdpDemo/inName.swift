//
//  inName.swift
//  FinsUdpDemo
//
//  Created by goemon12 on 2020/04/27.
//  Copyright © 2020 goemon12. All rights reserved.
//

import SwiftUI

struct inName: View {
    var lbl: String
    @Binding var num: Int
    
    var body: some View {
        HStack {
            Text(lbl)
                .padding(.leading, 5.0)
                .frame(width: 120, height: 40,alignment: .leading)
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))

            Picker(selection: $num, label: Text(lbl)) {
                Text("CIO").tag(0)
                Text("DM").tag(1)
                Text("E0").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.leading, 5.0)
            .frame(maxWidth: 1000, alignment: .leading)
            .frame(height: 40)
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
        }
    }
}
