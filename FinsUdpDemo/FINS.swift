import Foundation
import Network

let binChNames: [UInt8] = [0xb0, 0x82, 0x20]
let strChNames: [String] = ["CIO", "DM", "E0"]

class FINS: ObservableObject {
    @Published var txtView: String = "This is a pen.This is a pen.This is a pen.This is a pen.This is a pen."

    var connection: NWConnection?
    var sa1: UInt8? = UInt8(199)
    var da1: UInt8? = UInt8(  1)
    var sid: UInt8? = UInt8(  0)
    var addr: UInt16?
    var leng: UInt16?
    var name: Int?
    
    func open(txtHost: String, txtPort: String, intChName: Int, txtChAddr: String, txtChLeng: String) -> Bool {
        //IPアドレス
        let host = NWEndpoint.Host(txtHost)
        
        let tmp1 = UInt16(txtPort)
        if tmp1 == nil {
            return false
        }
        
        //ポートNO
        let port = NWEndpoint.Port(rawValue: tmp1!)
        if port == nil {
            return false
        }
        
        //宛先ノードNO
        let tmp2 = txtHost.components(separatedBy: ".")
        if (tmp2.count != 4) {
            return false
        }
        
        da1 = UInt8(tmp2[3])
        if da1 == nil {
            return false
        }
        
        name = intChName
        
        addr = UInt16(txtChAddr)
        if addr == nil {
            return false
        }
        
        leng = UInt16(txtChLeng)
        if leng == nil {
            return false
        }
        
        connection = NWConnection(host: host, port: port!, using: .udp)
        if (connection == nil) {
            return false
        }
        connection!.stateUpdateHandler = {(state) in
            if (state == .ready) {
                self.txtView = ""
                self.recv()
                self.send()
            }
        }
        connection!.start(queue: DispatchQueue.main)
        
        return true
    }
    
    func send() {
        let slen = 18
        var sbuf = [UInt8](repeating: 0x00, count: 20)
        sbuf[ 0] = 0x80
        sbuf[ 1] = 0x00
        sbuf[ 2] = 0x02
        sbuf[ 3] = 0x00//DNA
        sbuf[ 4] = da1!//DA1
        sbuf[ 5] = 0x00//DA2
        sbuf[ 6] = 0x00//SNA
        sbuf[ 7] = sa1!//SA1
        sbuf[ 8] = 0x00//SA2
        sbuf[ 9] = sid!//SID
        sid = (sid! + 1) % 0x10
        sbuf[10] = 0x01//MRC
        sbuf[11] = 0x01//SRC
        sbuf[12] = binChNames[name!] //CH NAME
        sbuf[13] = UInt8(addr! / 0x100)
        sbuf[14] = UInt8(addr! % 0x100)
        sbuf[15] = 0x00
        sbuf[16] = UInt8(leng! / 0x100)
        sbuf[17] = UInt8(leng! % 0x100)
        let sdat = Data(bytes: sbuf, count: slen)
        connection!.send(content: sdat, completion: .contentProcessed({(error) in
            if (error == nil) {
                self.txtView += "送信:"
                for i in 0 ..< slen {
                    self.txtView += String(format: " %02x", sbuf[i])
                }
                self.txtView += "\n\n"
            }
            else {
                self.txtView += "送信失敗\n\n"
            }
        }))
    }

    func recv() {
        connection!.receive(minimumIncompleteLength: 1, maximumLength: 1000, completion: {(rdat, _, _, error) in
            if (error == nil) {
                self.txtView += "受信:"
                for i in 0 ..< rdat!.count {
                    self.txtView += String(format: " %02x", [UInt8](rdat!)[i])
                }
                self.txtView += "\n\n"
                
                if (rdat!.count == self.leng! * 2 + 14) {
                    for i in 0 ..< Int(self.leng!) {
                        self.txtView += strChNames[self.name!]
                        self.txtView += String(format: " %04d CH", Int(self.addr!) + i)
                        self.txtView += String(format: " = %02x", [UInt8](rdat!)[14 + i * 2])
                        self.txtView += String(format: "%02x HEX\n", [UInt8](rdat!)[15 + i * 2])
                    }
                }
                self.txtView += "\n\n"
            }
            else {
                self.txtView += "受信失敗\n\n"
            }
        })
    }
}
