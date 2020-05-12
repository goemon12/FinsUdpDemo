import Foundation
import Network

class FINS: ObservableObject {
    @Published var txtView: String = "FINS/UDPデモ\n\nコマンド0501を送信して機器名称を取得する通信デモプログラムです。\n"

    var connection: NWConnection?
    var DstNet: UInt8?
    var DstNode: UInt8?
    var DstUnit: UInt8?
    var SrcNet: UInt8?
    var SrcNode: UInt8?
    var SrcUnit: UInt8?
    var sid: UInt8 = 0
    
    func open(txtHost: String, txtPort: String,
              txtDstNet: String, txtDstNode: String, txtDstUnit: String,
              txtSrcNet: String, txtSrcNode: String, txtSrcUnit: String) -> Bool {
        txtView = ""
        
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
        
        DstNet  = UInt8(txtDstNet)
        DstNode = UInt8(txtDstNode)
        DstUnit = UInt8(txtDstUnit)
        SrcNet  = UInt8(txtSrcNet)
        SrcNode = UInt8(txtSrcNode)
        SrcUnit = UInt8(txtSrcUnit)
        
        if ((DstNet == nil) || (DstNode == nil) || (DstUnit == nil)
            || (SrcNet == nil) || (SrcNode == nil) || (SrcUnit == nil)) {
            return false
        }
        
        connection = NWConnection(host: host, port: port!, using: .udp)
        if (connection == nil) {
            return false
        }
        connection!.stateUpdateHandler = {(state) in
            if (state == .ready) {
                self.txtView += "通信準備完了\n\n"
                self.recv()
                self.send()
            }
        }
        connection!.start(queue: DispatchQueue.main)
        
        return true
    }
    
    func send() {
        let slen = 12
        var sbuf = [UInt8](repeating: 0x00, count: 20)
        sbuf[ 0] = 0x80
        sbuf[ 1] = 0x00
        sbuf[ 2] = 0x02
        sbuf[ 3] = DstNet!  //DNA
        sbuf[ 4] = DstNode! //DA1
        sbuf[ 5] = DstUnit! //DA2
        sbuf[ 6] = SrcNet!  //SNA
        sbuf[ 7] = SrcNode! //SA1
        sbuf[ 8] = SrcUnit! //SA2
        sbuf[ 9] = sid //SID
        sid = (sid + 1) % 200
        sbuf[10] = 0x05 //MRC
        sbuf[11] = 0x01 //SRC
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
                
                self.txtView += "読出DATA:"
                for i in 14 ..< rdat!.count {
                    self.txtView += String(format: " %c", [UInt8](rdat!)[i])
                }
                self.txtView += "\n\n受信終了\n\n"
            }
            else {
                self.txtView += "受信失敗\n\n"
            }
        })
    }
}
