struct ScoreToBaseGPAMap {
    var name:String
    var baseGPA:Double
}
struct Components {
    var index:Int
    var type:ComponentType
}
enum ComponentType {
    case regular
    case maxGroup
}
struct Preset {
    var id:String
    var name: String
    var subtitle: String?
    var subjects:[Subject]
    var defaultScoreToBaseGPAMap:[ScoreToBaseGPAMap]
    var maxSubjectGroups:[maxSubjectGroup]?
    func getComponents() -> [Components] {
        var rturn:[Components]=[]
        for i in 0..<subjects.count {
            rturn.append(Components(index: i, type: .regular))
        }
        if (maxSubjectGroups != nil) {
            for i in 0..<maxSubjectGroups!.count {
                rturn.insert(Components(index:i, type:.maxGroup),at: maxSubjectGroups![i].insertAt)
            }
        }
        return rturn
    }
}
var presets:[Preset]=[]
func fastSubj(stype: String,name: String, weigh: Double) -> Subject { // purely for generating defaults
    if (stype=="eng") {
        var lvls=Array(repeating: Level(name:"",weight:weigh,offset:0),count: 5)
        lvls[4].name="AP"; lvls[4].offset=0
        lvls[3].name="H+"; lvls[3].offset=0.1
        lvls[2].name="H"; lvls[2].offset=0.2
        lvls[1].name="S+"; lvls[1].offset=0.4
        lvls[0].name="S"; lvls[0].offset=0.5
        return Subject(name:name,levels:lvls)
    } else if (stype=="chi") {
        var lvls=Array(repeating: Level(name:"",weight:weigh,offset:0),count: 5)
        lvls[4].name="H+"; lvls[4].offset=0.1
        lvls[3].name="H"; lvls[3].offset=0.2
        lvls[2].name="S/AP/5-7"; lvls[2].offset=0.3
        lvls[1].name="3-4"; lvls[1].offset=0.4
        lvls[0].name="1-2"; lvls[0].offset=0.5
        return Subject(name:name,levels:lvls)
    }
    var lvls=Array(repeating: Level(name:"",weight:weigh,offset:0),count: 4)
    lvls[3].name="AP"; lvls[3].offset=0
    lvls[2].name="H"; lvls[2].offset=0.2
    lvls[1].name="S+"; lvls[1].offset=0.35
    lvls[0].name="S"; lvls[0].offset=0.5
    return Subject(name:name,levels:lvls)
}
func initPresets() {
    var defaultScoreToBaseGPAMap:[ScoreToBaseGPAMap]=[]
    defaultScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"0", baseGPA: 0))
    defaultScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"60", baseGPA: 2.6))
    defaultScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"68", baseGPA: 3.0))
    defaultScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"73", baseGPA: 3.3))
    defaultScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"78", baseGPA: 3.6))
    defaultScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"83", baseGPA: 3.9))
    defaultScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"88", baseGPA: 4.2))
    defaultScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"93", baseGPA: 4.5))
    
    var tmp=Preset(id:"stockshsidgrade6",name:"Grade 6", subjects: [], defaultScoreToBaseGPAMap:defaultScoreToBaseGPAMap)
    var tmp2=fastSubj(stype: "eng", name: "English", weigh: 6.5)
    tmp2.levels.remove(at:4)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Math", weigh: 6.5)
    tmp2.levels.remove(at:3)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "chi", name: "Chinese", weigh: 5)
    tmp2.levels.remove(at:4)
    tmp2.levels[2].name="S"
    for i in 0..<tmp2.levels.count {
        tmp2.levels[i].offset-=0.1
    }
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Science", weigh: 2.5)
    tmp2.levels.remove(at:2)
    tmp2.levels.remove(at:2)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "History", weigh: 2.5)
    tmp2.levels.remove(at:2)
    tmp2.levels.remove(at:2)
    tmp.subjects.append(tmp2)
    
    presets.append(tmp);
    
    tmp=Preset(id:"stockshsidgrade7",name:"Grade 7", subjects: [], defaultScoreToBaseGPAMap:defaultScoreToBaseGPAMap)
    tmp2=fastSubj(stype: "eng", name: "English", weigh: 6)
    tmp2.levels.remove(at:4)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Math", weigh: 6)
    tmp2.levels.remove(at:3)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "History", weigh: 5)
    tmp2.levels.remove(at:3)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "chi", name: "Chinese", weigh: 5)
    tmp2.levels.remove(at:4)
    tmp2.levels[2].name="S/5-6"
    for i in 0..<tmp2.levels.count {
        tmp2.levels[i].offset-=0.1
    }
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Science", weigh: 3)
    tmp2.levels.remove(at:3)
    tmp2.levels.remove(at:1)
    tmp.subjects.append(tmp2)
    
    presets.append(tmp);
    
    tmp=Preset(id:"stockshsidgrade8",name:"Grade 8", subjects: [], defaultScoreToBaseGPAMap:defaultScoreToBaseGPAMap)
    tmp2=fastSubj(stype: "eng", name: "English", weigh: 6)
    tmp2.levels.remove(at:4)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Math", weigh: 6)
    tmp2.levels.remove(at:3)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Geography", weigh: 5)
    tmp2.levels.remove(at:3)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "chi", name: "Chinese", weigh: 5)
    tmp2.levels.remove(at:4)
    tmp2.levels[2].name="S/5-7"
    for i in 0..<tmp2.levels.count {
        tmp2.levels[i].offset-=0.1
    }
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Biology", weigh: 3.0)
    tmp2.levels.remove(at:3)
    tmp2.levels.remove(at:1)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Physics", weigh: 2.5)
    tmp2.levels.remove(at:3)
    tmp2.levels.remove(at:1)
    tmp.subjects.append(tmp2)
    
    presets.append(tmp);
    
    tmp=Preset(id:"stockshsidgrade9",name:"Grade 9", subjects: [], defaultScoreToBaseGPAMap:defaultScoreToBaseGPAMap)
    tmp2=fastSubj(stype: "eng", name: "English", weigh: 6.5)
    tmp2.levels.remove(at:4)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "Math", weigh: 6)
    tmp2.levels.remove(at:3)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype:"", name: "History", weigh: 4)
    tmp2.levels.remove(at:3)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Chemistry", weigh: 3.0)
    tmp2.levels.remove(at:3)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "chi", name: "Chinese", weigh: 3.0)
    tmp2.levels.remove(at:4)
    tmp2.levels[2].name="S/5-7"
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Elective", weigh: 3.0)
    tmp2.levels.remove(at:1)
    tmp2.levels.remove(at:2)
    tmp.subjects.append(tmp2)
    
    tmp2=fastSubj(stype: "", name: "Physics", weigh: 3.0)
    tmp2.levels.remove(at:3)
    tmp.subjects.append(tmp2)
    
    presets.append(tmp);
    
    tmp=Preset(id: "stockshsidgrade10", name:"Grade 10", subjects: [], defaultScoreToBaseGPAMap: defaultScoreToBaseGPAMap)
    tmp.subjects.append(fastSubj(stype:"",name:"Math",weigh:5.5))
    tmp.subjects[0].levels.remove(at:3)
    tmp.subjects.append(fastSubj(stype:"eng",name:"English",weigh:5.5))
    tmp.subjects.append(fastSubj(stype:"",name:"History",weigh:4))
    tmp.subjects[2].levels[3].weight=5
    tmp.subjects.append(fastSubj(stype:"",name:"Elective 1",weigh:3))
    tmp.subjects[3].levels.remove(at:1)
    tmp.subjects[3].levels[2].weight=4
    tmp.subjects.append(fastSubj(stype:"",name:"Elective 2",weigh:3))
    tmp.subjects[4].levels.remove(at:1)
    tmp.subjects[4].levels[2].weight=4
    tmp.subjects.append(fastSubj(stype:"chi",name:"Chinese",weigh:3))
    tmp.subjects.append(fastSubj(stype:"",name:"Chemistry",weigh:3))
    tmp.subjects[6].levels.remove(at:3)
    tmp.subjects.append(fastSubj(stype:"",name:"Physics",weigh:3))
    tmp.subjects[7].levels.remove(at:3)
    presets.append(tmp);
    
    var g11nonIbMath=fastSubj(stype: "", name: "Math", weigh: 6)
    g11nonIbMath.levels.remove(at: 1)
    g11nonIbMath.levels[g11nonIbMath.levels.count-1].name="A-L/AP"
    var g11nonIbChinese=fastSubj(stype: "chi", name: "Chinese", weigh: 3)
    g11nonIbChinese.levels[2].name="S/5-7"
    var g11Module2=fastSubj(stype:"",name:"Module 2",weigh:6)
    g11Module2.levels[g11Module2.levels.count-1].name="A-L/AP"
    var g11Module3=fastSubj(stype:"",name:"Module 3",weigh:4.5)
    g11Module3.levels.insert(.init(name: "A-L", weight: 6.0, offset: 0.0), at: 3)
    var g11Module45=fastSubj(stype: "", name: "Module 4/5", weigh: 3.0)
    g11Module45.levels.removeLast()
    var g11Module4=g11Module45
    g11Module4.name="Module 4"
    g11Module45.levels.append(.init(name: "A-L", weight: 6.0, offset: 0.0))
    g11Module45.levels.append(.init(name: "AP", weight: 4.5, offset: 0.0))
    var g11Module5=g11Module45
    g11Module5.name="Module 5"
    tmp=Preset(id: "stockshsidgrade11-2m2-1m3",name:"Grade 11", subtitle:"2x M2s, 1x M3", subjects: [], defaultScoreToBaseGPAMap: defaultScoreToBaseGPAMap)
    tmp.subjects.append(g11nonIbMath)
    tmp.subjects.append(fastSubj(stype:"eng",name:"English",weigh:6))
    tmp.subjects.append(g11Module2)
    tmp.subjects.append(g11Module2)
    tmp.subjects.append(g11Module3)
    tmp.subjects.append(g11nonIbChinese)
    presets.append(tmp);
    
    tmp=Preset(id: "stockshsidgrade11-1m2-1m3-1m45",name:"Grade 11", subtitle:"1x M2, M3, M4/5", subjects: [], defaultScoreToBaseGPAMap: defaultScoreToBaseGPAMap)
    tmp.subjects.append(g11nonIbMath)
    tmp.subjects.append(fastSubj(stype:"eng",name:"English",weigh:6))
    tmp.subjects.append(g11Module2)
    tmp.subjects.append(g11Module3)
    tmp.subjects.append(g11Module45)
    tmp.subjects.append(g11nonIbChinese)
    presets.append(tmp);
    
    tmp=Preset(id: "stockshsidgrade11-1m2-1m3-1m4-1m5",name:"Grade 11", subtitle:"1x M2, M3, M4, M5", subjects: [], defaultScoreToBaseGPAMap: defaultScoreToBaseGPAMap)
    tmp.subjects.append(g11nonIbMath)
    tmp.subjects.append(fastSubj(stype:"eng",name:"English",weigh:6))
    tmp.subjects.append(g11Module2)
    tmp.subjects.append(g11Module3)
    tmp.subjects.append(g11nonIbChinese)
    
    var mxGrp:[maxSubjectGroup]=[]
    var tmp3:[Subject]=[]
    tmp3.append(g11Module4)
    tmp3.append(g11Module5)
    mxGrp.append(maxSubjectGroup(insertAt:4,subjects: tmp3))
    
    tmp.maxSubjectGroups=mxGrp
    
    presets.append(tmp);
    
    var ibScoreToBaseGPAMap:[ScoreToBaseGPAMap]=[]
    ibScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"F", baseGPA: 0))
    ibScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"H4", baseGPA: 2.6))
    ibScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"L5", baseGPA: 3.0))
    ibScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"H5", baseGPA: 3.3))
    ibScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"L6", baseGPA: 3.6))
    ibScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"H6", baseGPA: 3.9))
    ibScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"L7", baseGPA: 4.2))
    ibScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"H7", baseGPA: 4.5))
    
    var letterGradesScoreToBaseGPAMap:[ScoreToBaseGPAMap]=[]
    letterGradesScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"F", baseGPA: 0))
    letterGradesScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"C-/C", baseGPA: 2.6))
    letterGradesScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"C+", baseGPA: 3.0))
    letterGradesScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"B-", baseGPA: 3.3))
    letterGradesScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"B", baseGPA: 3.6))
    letterGradesScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"B+", baseGPA: 3.9))
    letterGradesScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"A-", baseGPA: 4.2))
    letterGradesScoreToBaseGPAMap.append(ScoreToBaseGPAMap(name:"A/A+", baseGPA: 4.5))
    
    var earlyToKGradesToBaseGPAMap:[ScoreToBaseGPAMap]=[]
    earlyToKGradesToBaseGPAMap.append(ScoreToBaseGPAMap(name:"F", baseGPA: 0))
    earlyToKGradesToBaseGPAMap.append(ScoreToBaseGPAMap(name:"C", baseGPA: 2.5))
    earlyToKGradesToBaseGPAMap.append(ScoreToBaseGPAMap(name:"B", baseGPA: 4.0))
    earlyToKGradesToBaseGPAMap.append(ScoreToBaseGPAMap(name:"A", baseGPA: 4.5))
    
    tmp=Preset(id: "stockshsidgrade11-ib",name:"Grade 11", subtitle:"IB", subjects: [], defaultScoreToBaseGPAMap: ibScoreToBaseGPAMap)
    tmp.subjects.append(fastSubj(stype:"",name:"Math",weigh:1))
    tmp.subjects.append(fastSubj(stype:"eng",name:"English",weigh:1))
    tmp.subjects.append(fastSubj(stype:"chi",name:"Chinese",weigh:1))
    tmp.subjects.append(fastSubj(stype:"",name:"Elective 1",weigh:1))
    tmp.subjects.append(fastSubj(stype:"",name:"Elective 2",weigh:1))
    tmp.subjects.append(fastSubj(stype:"",name:"Elective 3",weigh:1))
    for i in 0..<tmp.subjects.count {
        tmp.subjects[i].levels = [.init(name: "IB", weight: 1, offset: 0)]
    }
    tmp.subjects.append(fastSubj(stype: "", name: "ToK", weigh: 0.5))
    tmp.subjects[tmp.subjects.count-1].customScoreToBaseGPAMap=earlyToKGradesToBaseGPAMap
    tmp.subjects[tmp.subjects.count-1].levels = [.init(name: "IB", weight: 0.5, offset: 0)]
    presets.append(tmp);
}
