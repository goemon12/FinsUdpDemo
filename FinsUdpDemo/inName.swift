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
                .padding(.all, 5)
                .frame(width: 120, height: 40, alignment: .bottomLeading)
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))


            Picker(selection: $num, label: Text(lbl)) {
                ForEach(0 ..< strChNames.count) {index in
                    Text(strChNames[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            .padding(.all, 5)
            .frame(maxWidth: 1000)
            .frame(height: 40, alignment: .bottomLeading)
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
        }
    }
}

struct inName_Previews: PreviewProvider {
    static var previews: some View {
        inName(lbl: "CH種類", num: .constant(0))
    }
}
