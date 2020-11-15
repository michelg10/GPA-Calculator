//
//  ViewController.swift
//  GPA Calculator
//
//  Created by LegitMichel777 on 2020/11/10.
//

import UIKit
struct subjView {
    var mstr: UIView!
    var sep: UIView!
    var lvlsel: UISegmentedControl
    var scsel: UISegmentedControl
    var pts: subj
}
var vws=[subjView]()
struct lvl {
    var name: String
    var weight: Double
    var offset: Double
}
struct subj {
    var nm: String
    var lvls:[lvl]
}
var subjs=[subj]()
struct bar {
    var lbound: Int
    var sc: Double
}
var bars=[bar]()
var Inexec=false
func fastSubj(stype: String,name: String, weigh: Double) -> subj { // purely for generating defaults
    if (stype=="eng") {
        var lvls=Array(repeating: lvl(name:"",weight:weigh,offset:0),count: 5)
        lvls[4].name="IB/AP"; lvls[4].offset=0
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
    var lvls=Array(repeating: lvl(name:"",weight:weigh,offset:0),count: 4)
    lvls[3].name="IB/AP"; lvls[3].offset=0
    lvls[2].name="H"; lvls[2].offset=0.2
    lvls[1].name="S+"; lvls[1].offset=0.35
    lvls[0].name="S"; lvls[0].offset=0.5
    return subj(nm:name,lvls:lvls)
}
func loadDefaults() {
    subjs.append(fastSubj(stype:"",name:"Math",weigh:5.5))
    subjs[0].lvls.remove(at:3)
    subjs.append(fastSubj(stype:"eng",name:"English",weigh:5.5))
    subjs.append(fastSubj(stype:"",name:"History",weigh:4))
    subjs[2].lvls[3].weight=5
    subjs.append(fastSubj(stype:"",name:"Elective 1",weigh:3))
    subjs[3].lvls[3].weight=4
    subjs.append(fastSubj(stype:"",name:"Elective 2",weigh:3))
    subjs[4].lvls[3].weight=4
    subjs.append(fastSubj(stype:"chi",name:"Chinese",weigh:3))
    subjs[5].lvls.remove(at:5)
    subjs.append(fastSubj(stype:"",name:"Chemistry",weigh:3))
    subjs[6].lvls.remove(at:3)
    subjs.append(fastSubj(stype:"",name:"Physics",weigh:3))
    subjs[7].lvls.remove(at:3)
    
    //!! bars must be in order
    bars.append(bar(lbound:0,sc:0))
    bars.append(bar(lbound:60,sc:2.6))
    bars.append(bar(lbound:68,sc:3.0))
    bars.append(bar(lbound:73,sc:3.3))
    bars.append(bar(lbound:78,sc:3.6))
    bars.append(bar(lbound:83,sc:3.9))
    bars.append(bar(lbound:88,sc:4.2))
    bars.append(bar(lbound:93,sc:4.5))
}
/*
func getBase(sc: Double) -> Double {
    var rturn=0.0
    for i in 0..<bars.count {
        if (sc>=bars[i].lbound) {
            rturn=bars[i].sc
        } else break;
    }
    return rturn
}
 */
class ViewController: UIViewController {
    @IBOutlet weak var stk: UIStackView!
    @IBOutlet weak var scrview: UIScrollView!
    @IBOutlet weak var editmsk: UIView!
    @IBOutlet weak var res: UILabel!
    @IBOutlet weak var resetmsk: UIView!
    @IBAction func editwei(_ sender: Any) {
        
    }
    @IBAction func reset(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        res.text=""
        for i in 0..<vws.count {
            vws[i].scsel.selectedSegmentIndex=0
            vws[i].lvlsel.selectedSegmentIndex=0
        }
    }
    var plcHldr=UISegmentedControl()
    func erasePersist() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    @objc func saveData() {
        //clear everything
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        usrdt.setValue(bars.count,forKey:"barsz")
        for i in 0..<bars.count {
            usrdt.setValue(bars[i].lbound,forKey:"barl\(i)")
            usrdt.setValue(bars[i].sc,forKey:"bars\(i)")
        }
        
        usrdt.setValue(subjs.count,forKey:"subjsz")
        for i in 0..<subjs.count {
            usrdt.setValue(subjs[i].nm,forKey:"subj\(i)")
            usrdt.setValue(subjs[i].lvls.count,forKey:"slvlsz\(i)")
            for j in 0..<subjs[i].lvls.count {
                usrdt.setValue(subjs[i].lvls[j].name,forKey:"lnm\(i),\(j)")
                usrdt.setValue(subjs[i].lvls[j].offset,forKey:"lof\(i),\(j)")
                usrdt.setValue(subjs[i].lvls[j].weight,forKey:"lwe\(i),\(j)")
            }
            usrdt.setValue(vws[i].lvlsel.selectedSegmentIndex,forKey:"sellvlseg\(i)")
            usrdt.setValue(vws[i].scsel.selectedSegmentIndex,forKey:"selscseg\(i)")
        }
        
        usrdt.setValue(true,forKey:"dt")
        usrdt.synchronize()
    }
    let usrdt=UserDefaults.standard
    var tmr=Timer()
    override func viewDidLoad() {
        tmr = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(saveData), userInfo: nil, repeats: true)
        res.text=""
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrview.layer.masksToBounds=true
        scrview.layer.cornerRadius=scrview.layer.bounds.width/40
        scrview.clipsToBounds=true
        editmsk.layer.masksToBounds=true
        editmsk.layer.cornerCurve = .continuous
        editmsk.layer.cornerRadius=editmsk.layer.bounds.width/8
        
        stk.layer.masksToBounds=true
        stk.layer.cornerCurve = .continuous
        stk.layer.cornerRadius=editmsk.layer.bounds.width/8
 
        resetmsk.clipsToBounds=true
        resetmsk.layer.masksToBounds=true
        resetmsk.layer.cornerCurve = .continuous
        resetmsk.layer.cornerRadius=editmsk.layer.bounds.width/8
        resetmsk.clipsToBounds=true
        if (usrdt.value(forKey:"dt")==nil) {
            loadDefaults()
            drawInter()
            saveData()
        } else {
            loadDefaults()
            //load data
            var lselrem=[Int]()
            var sselrem=[Int]()
            var brsz=usrdt.integer(forKey: "barsz")
            for i in 0..<brsz {
                var lb=0,sc=0.0
                lb=usrdt.integer(forKey: "barl\(i)")
                sc=usrdt.double(forKey: "bars\(i)")
//                bars.append(bar(lbound: lb, sc: sc))
            }
            var subjsz=usrdt.integer(forKey:"subjsz")
            for i in 0..<subjsz {
                var sname="",lvlcnt=0
                sname=usrdt.string(forKey:"subj\(i)")!
                lvlcnt=usrdt.integer(forKey:"slvlsz\(i)")
                var sublvl:[lvl]=[]
                for j in 0..<lvlcnt {
                    var lvlnm="",lvlof=0.0,lvlwe=0.0
                    lvlnm=usrdt.string(forKey: "lnm\(i),\(j)")!
                    lvlof=usrdt.double(forKey: "lof\(i),\(j)")
                    lvlwe=usrdt.double(forKey: "lwe\(i),\(j)")
//                    sublvl.append(lvl(name: lvlnm, weight: lvlwe, offset: lvlof))
                }
//                subjs.append(subj(nm: sname, lvls: sublvl))
                lselrem.append(usrdt.integer(forKey: "sellvlseg\(i)"))
                sselrem.append(usrdt.integer(forKey: "selscseg\(i)"))
            }
            drawInter()
            for i in 0..<subjsz {
                if (lselrem[i]>=vws[i].lvlsel.numberOfSegments) {
                    lselrem[i]=0
                    vws[i].lvlsel.selectedSegmentIndex=0
                } else {
                    vws[i].lvlsel.selectedSegmentIndex=lselrem[i]
                }
                if (sselrem[i]>=vws[i].lvlsel.numberOfSegments) {
                    sselrem[i]=0
                    vws[i].scsel.selectedSegmentIndex=0
                } else {
                    vws[i].scsel.selectedSegmentIndex=sselrem[i]
                }
            }
            updtc(segment:plcHldr)
        }
    }
    func drawInter() {
        for i in vws {
            i.mstr.removeFromSuperview()
        }
        vws.removeAll()
        for i in 0..<subjs.count {
            var mstr=UIView()
            stk.insertArrangedSubview(mstr, at: i+1)
            mstr.translatesAutoresizingMaskIntoConstraints=false
            var nv=subjView(mstr: mstr, sep: UIView(), lvlsel: UISegmentedControl(), scsel: UISegmentedControl(),pts: subj(nm:"", lvls: []))
            if (i==0) {
                var bigS=UIView()
                bigS.translatesAutoresizingMaskIntoConstraints=false
                bigS.widthAnchor.constraint(equalToConstant: stk.frame.width).isActive=true
                bigS.heightAnchor.constraint(equalToConstant:2).isActive=true
                bigS.backgroundColor=UIColor.init(named:"sep")
                nv.sep=bigS
            } else {
                var smolS=UIView()
                smolS.translatesAutoresizingMaskIntoConstraints=false
                smolS.widthAnchor.constraint(equalToConstant: stk.frame.width-20).isActive=true
                smolS.heightAnchor.constraint(equalToConstant:2).isActive=true
                smolS.backgroundColor=UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                smolS.backgroundColor=UIColor.init(named:"sep")
                smolS.clipsToBounds = true
                smolS.layer.cornerRadius = 1
                smolS.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
                nv.sep=smolS
            }
            mstr.addSubview(nv.sep)
            nv.sep.topAnchor.constraint(equalTo:mstr.topAnchor, constant:0).isActive=true
            nv.sep.trailingAnchor.constraint(equalTo: mstr.trailingAnchor, constant: 0).isActive=true
            mstr.heightAnchor.constraint(equalToConstant:108).isActive=true
            mstr.leadingAnchor.constraint(equalTo:stk.leadingAnchor).isActive=true
            mstr.trailingAnchor.constraint(equalTo:stk.trailingAnchor).isActive=true
            
            var subjlbl=UILabel()
            subjlbl.translatesAutoresizingMaskIntoConstraints=false
            subjlbl.text=subjs[i].nm
            mstr.addSubview(subjlbl)
            subjlbl.font=UIFont.systemFont(ofSize:25)
            subjlbl.sizeToFit()
            subjlbl.topAnchor.constraint(equalTo: mstr.topAnchor, constant: 15).isActive=true
            subjlbl.leadingAnchor.constraint(equalTo: mstr.leadingAnchor, constant: 10).isActive=true
            
            var lvlsel=UISegmentedControl()
            lvlsel.apportionsSegmentWidthsByContent=true
            lvlsel.translatesAutoresizingMaskIntoConstraints=false
            for j in 0..<subjs[i].lvls.count {
                lvlsel.insertSegment(withTitle: String(subjs[i].lvls[j].name), at: j, animated: false)
            }
            mstr.addSubview(lvlsel)
            lvlsel.selectedSegmentIndex=0
            lvlsel.topAnchor.constraint(equalTo: mstr.topAnchor, constant: 15).isActive=true
            lvlsel.trailingAnchor.constraint(equalTo: mstr.trailingAnchor, constant: -10).isActive=true
//            lvlsel.widthAnchor.constraint(equalToConstant: stk.frame.width-subjlbl.frame.width-50).isActive=true
            lvlsel.widthAnchor.constraint(equalToConstant: 220).isActive=true
            nv.lvlsel=lvlsel
            lvlsel.addTarget(self, action: #selector(updtc), for:.valueChanged)
            
            var scsel=UISegmentedControl()
            scsel.apportionsSegmentWidthsByContent=true
            scsel.translatesAutoresizingMaskIntoConstraints=false
            for i in 0..<bars.count {
                scsel.insertSegment(withTitle: String(bars[i].lbound), at: i, animated: false)
            }
            mstr.addSubview(scsel)
            scsel.selectedSegmentIndex=0
            scsel.topAnchor.constraint(equalTo: mstr.topAnchor, constant: 60).isActive=true
            scsel.trailingAnchor.constraint(equalTo: mstr.trailingAnchor, constant:-10).isActive=true
            scsel.widthAnchor.constraint(equalToConstant: stk.frame.width-20).isActive=true
            scsel.centerXAnchor.constraint(equalTo: mstr.centerXAnchor).isActive=true
            nv.scsel=scsel
            scsel.addTarget(self, action: #selector(updtc), for:.valueChanged)
            
            nv.pts=subjs[i]
            vws.append(nv)
        }
    }
    @objc func updtc(segment: UISegmentedControl) {
        if (segment != plcHldr) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        var ans=0.0
        var ttlCred=0.0
        for i in 0..<vws.count {
            var bs=bars[vws[i].scsel.selectedSegmentIndex].sc-vws[i].pts.lvls[vws[i].lvlsel.selectedSegmentIndex].offset
            bs=max(bs,0)
            bs*=vws[i].pts.lvls[vws[i].lvlsel.selectedSegmentIndex].weight
            ans+=bs
            ttlCred+=vws[i].pts.lvls[vws[i].lvlsel.selectedSegmentIndex].weight
        }
        ans/=ttlCred
        res.text="Your GPA: "+String(round(ans*1000)/1000.0)
    }
}
