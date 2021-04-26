struct scl {
    var sc:Int
    var base:Double
}
struct loadObj {
    var ind:Int
    var locc:loc
}
var ldobjs:[loadObj]=[]
enum loc {
    case reg
    case mxg
}
struct preset {
    var id:String
    var name: String
    var subttl: String?
    var subjs:[subj]
    var scds:[scl]
    var mxSubs:[mxSubjGrp]?
    func enul() -> [loadObj] {
        var rturn:[loadObj]=[]
        for i in 0..<subjs.count {
            rturn.append(loadObj(ind: i, locc: .reg))
        }
        if (mxSubs != nil) {
            for i in 0..<mxSubs!.count {
                rturn.insert(loadObj(ind:i, locc:.mxg),at: mxSubs![i].insAt)
            }
        }
        return rturn
    }
}
var presets:[preset]=[]
func fastSubj(stype: String,name: String, weigh: Double) -> subj { // purely for generating defaults
    if (stype=="eng") {
        var lvls=Array(repeating: lvl(name:"",weight:weigh,offset:0),count: 6)
        lvls[5].name="IB"; lvls[5].offset=0
        lvls[4].name="AP"; lvls[4].offset=0
        lvls[3].name="H+"; lvls[3].offset=0.1
        lvls[2].name="H"; lvls[2].offset=0.2
        lvls[1].name="S+"; lvls[1].offset=0.4
        lvls[0].name="S"; lvls[0].offset=0.5
        return subj(nm:name,lvls:lvls)
    } else if (stype=="chi") {
        var lvls=Array(repeating: lvl(name:"",weight:weigh,offset:0),count: 6)
        lvls[5].name="IB"; lvls[5].offset=0
        lvls[4].name="H+"; lvls[4].offset=0.1
        lvls[3].name="H"; lvls[3].offset=0.2
        lvls[2].name="S/AP/5-7"; lvls[2].offset=0.3
        lvls[1].name="3-4"; lvls[1].offset=0.4
        lvls[0].name="1-2"; lvls[0].offset=0.5
        return subj(nm:name,lvls:lvls)
    }
    var lvls=Array(repeating: lvl(name:"",weight:weigh,offset:0),count: 5)
    lvls[4].name="IB"; lvls[4].offset=0
    lvls[3].name="AP"; lvls[3].offset=0
    lvls[2].name="H"; lvls[2].offset=0.2
    lvls[1].name="S+"; lvls[1].offset=0.35
    lvls[0].name="S"; lvls[0].offset=0.5
    return subj(nm:name,lvls:lvls)
}
func initPresets() {
    var ascl:[scl]=[]
    ascl.append(scl(sc:0, base: 0))
    ascl.append(scl(sc:60, base: 2.6))
    ascl.append(scl(sc:68, base: 3.0))
    ascl.append(scl(sc:73, base: 3.3))
    ascl.append(scl(sc:78, base: 3.6))
    ascl.append(scl(sc:83, base: 3.9))
    ascl.append(scl(sc:88, base: 4.2))
    ascl.append(scl(sc:93, base: 4.5))
    
    var tmp=preset(id:"stockshsidgrade6",name:"Grade 6", subjs: [], scds:ascl)
    var tmp2=fastSubj(stype: "eng", name: "English", weigh: 6.5)
    tmp2.lvls.remove(at:4)
    tmp2.lvls.remove(at:4)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Math", weigh: 6.5)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "chi", name: "Chinese", weigh: 5)
    tmp2.lvls.remove(at:4)
    tmp2.lvls.remove(at:4)
    tmp2.lvls[2].name="S"
    for i in 0..<tmp2.lvls.count {
        tmp2.lvls[i].offset-=0.1
    }
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Science", weigh: 2.5)
    tmp2.lvls.remove(at:2)
    tmp2.lvls.remove(at:2)
    tmp2.lvls.remove(at:2)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "History", weigh: 2.5)
    tmp2.lvls.remove(at:2)
    tmp2.lvls.remove(at:2)
    tmp2.lvls.remove(at:2)
    tmp.subjs.append(tmp2)
    
    presets.append(tmp);
    
    tmp=preset(id:"stockshsidgrade7",name:"Grade 7", subjs: [], scds:ascl)
    tmp2=fastSubj(stype: "eng", name: "English", weigh: 6)
    tmp2.lvls.remove(at:4)
    tmp2.lvls.remove(at:4)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Math", weigh: 6)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "History", weigh: 5)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "chi", name: "Chinese", weigh: 5)
    tmp2.lvls.remove(at:4)
    tmp2.lvls.remove(at:4)
    tmp2.lvls[2].name="S/5-6"
    for i in 0..<tmp2.lvls.count {
        tmp2.lvls[i].offset-=0.1
    }
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Science", weigh: 3)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:1)
    tmp.subjs.append(tmp2)
    
    presets.append(tmp);
    
    tmp=preset(id:"stockshsidgrade8",name:"Grade 8", subjs: [], scds:ascl)
    tmp2=fastSubj(stype: "eng", name: "English", weigh: 6)
    tmp2.lvls.remove(at:4)
    tmp2.lvls.remove(at:4)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Math", weigh: 6)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Geography", weigh: 5)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "chi", name: "Chinese", weigh: 5)
    tmp2.lvls.remove(at:4)
    tmp2.lvls.remove(at:4)
    tmp2.lvls[2].name="S/5-7"
    for i in 0..<tmp2.lvls.count {
        tmp2.lvls[i].offset-=0.1
    }
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Biology", weigh: 3.0)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:1)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Physics", weigh: 2.5)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:1)
    tmp.subjs.append(tmp2)
    
    presets.append(tmp);
    
    tmp=preset(id:"stockshsidgrade9",name:"Grade 9", subjs: [], scds:ascl)
    tmp2=fastSubj(stype: "eng", name: "English", weigh: 6.5)
    tmp2.lvls.remove(at:4)
    tmp2.lvls.remove(at:4)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Math", weigh: 6)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "History", weigh: 4)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Chemistry", weigh: 3.0)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "chi", name: "Chinese", weigh: 3.0)
    tmp2.lvls.remove(at:4)
    tmp2.lvls.remove(at:4)
    tmp2.lvls[2].name="S/5-7"
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Elective", weigh: 3.0)
    tmp2.lvls.remove(at:1)
    tmp2.lvls.remove(at:2)
    tmp2.lvls.remove(at:2)
    tmp.subjs.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Physics", weigh: 3.0)
    tmp2.lvls.remove(at:3)
    tmp2.lvls.remove(at:3)
    tmp.subjs.append(tmp2)
    
    presets.append(tmp);
    
    tmp=preset(id: "stockshsidgrade10", name:"Grade 10", subjs: [], scds: ascl)
    tmp.subjs.append(fastSubj(stype:"",name:"Math",weigh:5.5))
    tmp.subjs[0].lvls.remove(at:3)
    tmp.subjs[0].lvls.remove(at:3)
    tmp.subjs.append(fastSubj(stype:"eng",name:"English",weigh:5.5))
    tmp.subjs[1].lvls.remove(at:5)
    tmp.subjs.append(fastSubj(stype:"",name:"History",weigh:4))
//    tmp.subjs[2].lvls[3].weight=5
    tmp.subjs[2].lvls.remove(at:4)
    tmp.subjs.append(fastSubj(stype:"",name:"Elective 1",weigh:3))
    tmp.subjs[3].lvls.remove(at:1)
//    tmp.subjs[3].lvls[3].weight=4
    tmp.subjs[3].lvls.remove(at:3)
    tmp.subjs.append(fastSubj(stype:"",name:"Elective 2",weigh:3))
    tmp.subjs[4  ].lvls.remove(at:1)
//    tmp.subjs[4].lvls[3].weight=4
    tmp.subjs[4].lvls.remove(at:3)
    tmp.subjs.append(fastSubj(stype:"chi",name:"Chinese",weigh:3))
    tmp.subjs[5].lvls.remove(at:5)
    tmp.subjs.append(fastSubj(stype:"",name:"Chemistry",weigh:3))
    tmp.subjs[6].lvls.remove(at:3)
    tmp.subjs[6].lvls.remove(at:3)
    tmp.subjs.append(fastSubj(stype:"",name:"Physics",weigh:3))
    tmp.subjs[7].lvls.remove(at:3)
    tmp.subjs[7].lvls.remove(at:3)
    presets.append(tmp);
    
    tmp=preset(id: "stockshsidgrade11-2m2-1m3",name:"Grade 11", subttl:"1x M1, 2x M2s", subjs: [], scds: ascl)
    tmp.subjs.append(fastSubj(stype:"",name:"Math",weigh:6))
    tmp.subjs.append(fastSubj(stype:"eng",name:"English",weigh:6))
    tmp.subjs.append(fastSubj(stype:"",name:"Module 2",weigh:6))
    tmp.subjs.append(fastSubj(stype:"",name:"Module 2",weigh:4.5))
    tmp.subjs.append(fastSubj(stype:"",name:"Module 3",weigh:4.5))
    tmp.subjs.append(fastSubj(stype:"chi",name:"Chinese",weigh:3))
    presets.append(tmp);
    
    tmp=preset(id: "stockshsidgrade11-1m2-1m3-1m45",name:"Grade 11", subttl:"1x M2, M3, M4/5", subjs: [], scds: ascl)
    tmp.subjs.append(fastSubj(stype:"",name:"Math",weigh:6))
    tmp.subjs.append(fastSubj(stype:"eng",name:"English",weigh:6))
    tmp.subjs.append(fastSubj(stype:"",name:"Module 2",weigh:6))
    tmp.subjs.append(fastSubj(stype:"",name:"Module 3",weigh:4.5))
    tmp.subjs.append(fastSubj(stype:"",name:"Module 4/5",weigh:4.5))
    tmp.subjs.append(fastSubj(stype:"chi",name:"Chinese",weigh:3))
    presets.append(tmp);
    
    tmp=preset(id: "stockshsidgrade11-1m2-1m3-1m4-1m5",name:"Grade 11", subttl:"1x M2, M3, M4, M5", subjs: [], scds: ascl)
    tmp.subjs.append(fastSubj(stype:"",name:"Math",weigh:6))
    tmp.subjs.append(fastSubj(stype:"eng",name:"English",weigh:6))
    tmp.subjs.append(fastSubj(stype:"",name:"Module 2",weigh:6))
    tmp.subjs.append(fastSubj(stype:"",name:"Module 3",weigh:4.5))
    tmp.subjs.append(fastSubj(stype:"chi",name:"Chinese",weigh:4.5))
    
    var mxGrp:[mxSubjGrp]=[]
    var tmp3:[subj]=[]
    tmp3.append(fastSubj(stype:"", name:"Module 4", weigh:3))
    tmp3.append(fastSubj(stype:"", name:"Module 5", weigh:3))
    mxGrp.append(mxSubjGrp(insAt:4,subjs: tmp3))
    
    tmp.mxSubs=mxGrp
    
    presets.append(tmp);
}
