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
    var subjlbl: UILabel
}
var vws=[subjView]()
struct mxView {
    var barShow: Gradient
    var mstrView: UIStackView
}
var mxhdlr=[mxView]()
struct lvl {
    var name: String
    var weight: Double
    var offset: Double
}
struct subj {
    var nm: String
    var lvls:[lvl]
}
struct mxSubjGrp {
    var insAt:Int
    var subjs:[subj]
}
var curP:preset?
var lgradstop:[Gradient?]=[] // lgrad
var lgradsbot:[Gradient?]=[] // lgrad
struct bar {
    var lbound: Int
    var sc: Double
}
func loadDefaults() {
    curP=presets[4]
}
func findPreset(toF: String) {
    curP=nil
    for i in 0..<presets.count {
        if (presets[i].id==toF) {
            curP=presets[i]
            break
        }
    }
}
var autosave=true
var bottomPadding:UIView? = nil
class ViewController: UIViewController {
    //TODO: Improve placement
    @IBOutlet weak var stk: UIStackView!
    @IBOutlet weak var scrview: UIScrollView!
    @IBOutlet weak var editmsk: UIView!
    @IBOutlet weak var res: UILabel!
    @IBOutlet weak var resetmsk: UIView!
    @IBAction func editwei(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    @IBAction func reset(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        for i in 0..<vws.count {
            vws[i].scsel.selectedSegmentIndex=0
            vws[i].lvlsel.selectedSegmentIndex=0
        }
        updtc(segment:plcHldr)
    }
    var plcHldr=UISegmentedControl()
    func erasePersist() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    @objc func saveData() {
        if (autosave) {
            autosave=false
            //clear everything
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            usrdt.setValue(curP?.id,forKey:"preset")
            let rng=curP!.enul()
            var tot=0
            for i in 0..<rng.count {
                if (rng[i].locc==loc.mxg) {
                    for _ in 0..<curP!.mxSubs![rng[i].ind].subjs.count {
                        usrdt.setValue(vws[tot].lvlsel.selectedSegmentIndex,forKey:"sellvlseg\(tot)")
                        usrdt.setValue(vws[tot].scsel.selectedSegmentIndex,forKey:"selscseg\(tot)")
                        tot=tot+1
                    }
                } else {
                    usrdt.setValue(vws[tot].lvlsel.selectedSegmentIndex,forKey:"sellvlseg\(tot)")
                    usrdt.setValue(vws[tot].scsel.selectedSegmentIndex,forKey:"selscseg\(tot)")
                    tot=tot+1
                }
            }
            
            usrdt.setValue(true,forKey:"dt")
            usrdt.synchronize()
            autosave=true
        }
    }
    let usrdt=UserDefaults.standard
    @objc func updtPre() {
        drawInter(doSave:true)
    }
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(updtPre), name: Notification.Name("updtPre"), object: nil)
        initPresets()
        self.navigationController?.navigationBar.prefersLargeTitles=true
        res.text=""
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrview.layer.masksToBounds=true
        scrview.layer.cornerRadius=scrview.layer.bounds.width/35
        scrview.layer.cornerCurve = .continuous
        scrview.clipsToBounds=true
        scrview.showsVerticalScrollIndicator=false
        editmsk.layer.masksToBounds=true
        editmsk.layer.cornerCurve = .continuous
        editmsk.layer.cornerRadius=editmsk.layer.bounds.height/2
        
        stk.layer.masksToBounds=true
        stk.layer.cornerCurve = .continuous
        stk.layer.cornerRadius=stk.layer.bounds.width/35
 
        resetmsk.clipsToBounds=true
        resetmsk.layer.masksToBounds=true
        resetmsk.layer.cornerCurve = .continuous
        resetmsk.layer.cornerRadius=editmsk.layer.bounds.height/2
        
        //MARK: Load from user data
        if (usrdt.value(forKey:"dt")==nil||usrdt.value(forKey:"preset")==nil) {
            loadDefaults()
            drawInter(doSave:true)
            updtc(segment:plcHldr)
        } else {
            var selPreset=usrdt.string(forKey:"preset")!
            findPreset(toF: selPreset)
            var gotPrst=false
            if (curP==nil) {
                loadDefaults()
                drawInter(doSave:true)
                updtc(segment:plcHldr)
                return
            }
            //load data
            var prest=usrdt.value(forKey:"preset")!
            drawInter(doSave:false)
            for i in 0..<vws.count {
                var lselrem=usrdt.value(forKey:"sellvlseg\(i)")
                var sselrem=usrdt.value(forKey:"selscseg\(i)")
                if (lselrem is Int&&sselrem is Int) {
                    if ((lselrem as! Int) < vws[i].lvlsel.numberOfSegments&&(sselrem as! Int) < vws[i].scsel.numberOfSegments&&(sselrem as! Int)>=0&&(lselrem as! Int)>=0) {
                        vws[i].lvlsel.selectedSegmentIndex=lselrem as! Int
                        vws[i].scsel.selectedSegmentIndex=sselrem as! Int
                    } else {
                        vws[i].lvlsel.selectedSegmentIndex=0
                        vws[i].scsel.selectedSegmentIndex=0
                    }
                } else {
                    vws[i].lvlsel.selectedSegmentIndex=0
                    vws[i].scsel.selectedSegmentIndex=0
                }
            }
            updtc(segment:plcHldr)
        }
    }
    var mxObjCount=0
    let cellhei=108
    func drawInter(doSave:Bool) {
        if (bottomPadding != nil) {
            bottomPadding!.removeFromSuperview()
        }
        assert(curP != nil,"Draw called when preset is nil!")
        for i in vws {
            i.mstr.removeFromSuperview()
        }
        vws.removeAll()
        for i in 0..<mxhdlr.count {
            mxhdlr[i].mstrView.removeFromSuperview()
        }
        lstmax.removeAll()
        var ldobjs=curP!.enul()
        mxObjCount=0
        if (curP!.mxSubs != nil) {
            for i in 0..<curP!.mxSubs!.count {
                mxObjCount+=curP!.mxSubs![i].subjs.count
            }
            alphTr=[[DispatchWorkItem]](repeating: [], count: mxObjCount)
            lstmax=[Int](repeating:0, count:curP!.mxSubs!.count)
            gradTr=[[DispatchWorkItem]](repeating:[], count:curP!.mxSubs!.count)
            gradPos=[Double](repeating: 0, count: curP!.mxSubs!.count)
            for i in 0..<curP!.mxSubs!.count {
                lstmax[i] = -1
            }
        }
        var paren:mxView? = nil
        let gradw=7
        lgradstop.removeAll()
        lgradsbot.removeAll()
        if (curP!.mxSubs != nil) {
            lgradstop=[Gradient?](repeating: nil, count: curP!.mxSubs!.count)
            lgradsbot=[Gradient?](repeating: nil, count: curP!.mxSubs!.count)
        }
        for i in 0..<ldobjs.count {
            if (ldobjs[i].locc==loc.mxg) {
                var newpar=UIStackView()
                newpar.distribution = .fill
                newpar.axis = .horizontal
                paren=mxView(barShow: Gradient(), mstrView: newpar)
                mxhdlr.append(paren!)
                stk.addArrangedSubview(newpar)
                newpar.translatesAutoresizingMaskIntoConstraints=false
                
                var miniCont=UIStackView()
                newpar.addArrangedSubview(miniCont)
                newpar.addSubview(miniCont)
                miniCont.topAnchor.constraint(equalTo: newpar.topAnchor).isActive=true
                miniCont.bottomAnchor.constraint(equalTo: newpar.bottomAnchor).isActive=true
                miniCont.translatesAutoresizingMaskIntoConstraints=false
                miniCont.alignment = .fill
                miniCont.axis = .vertical
                miniCont.distribution = .fill
                var gradCont=UIView()
                gradCont.translatesAutoresizingMaskIntoConstraints=false
                gradCont.widthAnchor.constraint(equalToConstant: CGFloat(gradw)).isActive=true
                newpar.insertArrangedSubview(gradCont,at: 0)
                var topS=UIView()
                if i==0 {
                    topS.translatesAutoresizingMaskIntoConstraints=false
                    topS.heightAnchor.constraint(equalToConstant:2).isActive=true
                    topS.backgroundColor=UIColor.init(named:"sep")
                    stk.addArrangedSubview(topS)
                }
                for j in 0..<curP!.mxSubs![ldobjs[i].ind].subjs.count {
                    var subjcont=UIView()
                    subjcont.translatesAutoresizingMaskIntoConstraints=false
                    var amx=subjView(mstr: subjcont, sep: UIView(), lvlsel: UISegmentedControl(), scsel: UISegmentedControl(), subjlbl: UILabel())
                    if (i+j != 0) {
                        var sepContView=UIView()
                        topS=UIView()
                        topS.translatesAutoresizingMaskIntoConstraints=false
                        topS.heightAnchor.constraint(equalToConstant:2).isActive=true
                        topS.backgroundColor=UIColor.init(named:"sep")
                        sepContView.addSubview(topS)
                        miniCont.addArrangedSubview(sepContView)
                        sepContView.translatesAutoresizingMaskIntoConstraints=false
                        sepContView.trailingAnchor.constraint(equalTo: miniCont.trailingAnchor).isActive=true
                        topS.topAnchor.constraint(equalTo: sepContView.topAnchor).isActive=true
                        topS.bottomAnchor.constraint(equalTo: sepContView.bottomAnchor).isActive=true
                        topS.leadingAnchor.constraint(equalTo: sepContView.leadingAnchor, constant: CGFloat(20-gradw)).isActive=true
                        topS.trailingAnchor.constraint(equalTo: sepContView.trailingAnchor).isActive=true
                        topS.layer.cornerRadius=1
                        topS.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
                        topS.clipsToBounds=true
                    }
                    amx.sep=topS
                    miniCont.addArrangedSubview(subjcont)
                    subjcont.heightAnchor.constraint(equalToConstant:CGFloat(cellhei)).isActive=true
                    
                    var subjlbl=UILabel()
                    subjlbl.translatesAutoresizingMaskIntoConstraints=false
                    subjlbl.text=curP!.mxSubs![ldobjs[i].ind].subjs[j].nm
                    subjcont.addSubview(subjlbl)
                    subjlbl.font=UIFont.systemFont(ofSize:25)
                    subjlbl.topAnchor.constraint(equalTo: subjcont.topAnchor, constant: 15).isActive=true
                    subjlbl.leadingAnchor.constraint(equalTo: subjcont.leadingAnchor, constant: CGFloat(10-gradw)).isActive=true
                    subjlbl.textColor=UIColor.init(named:"deselText")
                    
                    subjlbl=UILabel()
                    subjlbl.translatesAutoresizingMaskIntoConstraints=false
                    subjlbl.text=curP!.mxSubs![ldobjs[i].ind].subjs[j].nm
                    subjcont.addSubview(subjlbl)
                    subjlbl.font=UIFont.systemFont(ofSize:25)
                    subjlbl.topAnchor.constraint(equalTo: subjcont.topAnchor, constant: 15).isActive=true
                    subjlbl.leadingAnchor.constraint(equalTo: subjcont.leadingAnchor, constant: CGFloat(10-gradw)).isActive=true
                    amx.subjlbl=subjlbl
                    
                    var lvlsel=UISegmentedControl()
                    amx.lvlsel=lvlsel
                    lvlsel.apportionsSegmentWidthsByContent=true
                    lvlsel.translatesAutoresizingMaskIntoConstraints=false
                    for k in 0..<curP!.mxSubs![ldobjs[i].ind].subjs[j].lvls.count {
                        lvlsel.insertSegment(withTitle: String(curP!.mxSubs![ldobjs[i].ind].subjs[j].lvls[k].name), at: k, animated: false)
                    }
                    subjcont.addSubview(lvlsel)
                    lvlsel.selectedSegmentIndex=0
                    lvlsel.topAnchor.constraint(equalTo: subjcont.topAnchor, constant: 15).isActive=true
                    amx.lvlsel=lvlsel
                    lvlsel.addTarget(self, action: #selector(updtc), for:.valueChanged)
                    
                    var scsel=UISegmentedControl()
                    amx.scsel=scsel
                    scsel.apportionsSegmentWidthsByContent=true
                    scsel.translatesAutoresizingMaskIntoConstraints=false
                    for k in 0..<curP!.scds.count {
                        scsel.insertSegment(withTitle: String(curP!.scds[k].sc), at: k, animated: false)
                    }
                    subjcont.addSubview(scsel)
                    scsel.selectedSegmentIndex=0
                    scsel.topAnchor.constraint(equalTo: subjcont.topAnchor, constant: 60).isActive=true
                    amx.scsel=scsel
                    scsel.addTarget(self, action: #selector(updtc), for:.valueChanged)
                    
                    amx.scsel.trailingAnchor.constraint(equalTo: stk.trailingAnchor, constant:-10).isActive=true
                    amx.scsel.leadingAnchor.constraint(equalTo: stk.leadingAnchor, constant:10).isActive=true
                    amx.lvlsel.trailingAnchor.constraint(equalTo: stk.trailingAnchor, constant: -10).isActive=true
                    amx.lvlsel.leadingAnchor.constraint(equalTo: stk.leadingAnchor, constant: 140).isActive=true
                    vws.append(amx)
                }
                var gradMsk=UIView()
                gradMsk.translatesAutoresizingMaskIntoConstraints=false
                gradCont.addSubview(gradMsk)
                gradMsk.widthAnchor.constraint(equalToConstant: 3).isActive=true
                gradMsk.topAnchor.constraint(equalTo: gradCont.topAnchor, constant: 17).isActive=true
                gradMsk.bottomAnchor.constraint(equalTo: gradCont.bottomAnchor, constant: -15).isActive=true
                gradMsk.leadingAnchor.constraint(equalTo: gradCont.leadingAnchor, constant: 3).isActive=true
                gradMsk.layer.cornerRadius=1.5
                gradMsk.clipsToBounds=true
                
                var botgrad=Gradient()
                botgrad.translatesAutoresizingMaskIntoConstraints=false
                botgrad.diagonalMode=false
                gradMsk.addSubview(botgrad)
                botgrad.widthAnchor.constraint(equalToConstant: 3).isActive=true
                botgrad.topAnchor.constraint(equalTo: gradCont.topAnchor, constant: 17).isActive=true
                botgrad.bottomAnchor.constraint(equalTo: gradCont.bottomAnchor, constant: -15).isActive=true
                botgrad.leadingAnchor.constraint(equalTo: gradCont.leadingAnchor, constant: 3).isActive=true
                botgrad.clipsToBounds=true
                botgrad.startColor=UIColor.init(named:"gradProm")!
                botgrad.endColor=UIColor.init(named:"gradDesel")!
                botgrad.updt()
                lgradsbot[ldobjs[i].ind]=botgrad
                
                //MARK: Upgrad
                var upgrad=Gradient()
                upgrad.translatesAutoresizingMaskIntoConstraints=false
                upgrad.diagonalMode=false
                gradMsk.addSubview(upgrad)
                upgrad.widthAnchor.constraint(equalToConstant: 3).isActive=true
                upgrad.topAnchor.constraint(equalTo: gradCont.topAnchor, constant: 17).isActive=true
                upgrad.bottomAnchor.constraint(equalTo: gradCont.bottomAnchor, constant: -15).isActive=true
                upgrad.leadingAnchor.constraint(equalTo: gradCont.leadingAnchor, constant: 3).isActive=true
                upgrad.startColor=UIColor.init(named:"gradDesel")!
                upgrad.endColor=UIColor.init(named:"gradProm")!
                upgrad.updt()
                var upgradMsk=UIView(frame: CGRect(x: 0,y: 0,width: 4,height: 0))
                upgradMsk.backgroundColor = .black
                upgrad.mask=upgradMsk
                lgradstop[ldobjs[i].ind]=upgrad
                
                continue
            }
            var mstr=UIView()
            stk.addArrangedSubview(mstr)
            mstr.translatesAutoresizingMaskIntoConstraints=false
            
            var nv=subjView(mstr: mstr, sep: UIView(), lvlsel: UISegmentedControl(), scsel: UISegmentedControl(), subjlbl: UILabel())
            if (i==0) {
                var bigS=UIView()
                bigS.translatesAutoresizingMaskIntoConstraints=false
                bigS.heightAnchor.constraint(equalToConstant:2).isActive=true
                bigS.backgroundColor=UIColor.init(named:"sep")
                nv.sep=bigS
            } else {
                var smolS=UIView()
                smolS.translatesAutoresizingMaskIntoConstraints=false
                smolS.heightAnchor.constraint(equalToConstant:2).isActive=true
                smolS.backgroundColor=UIColor.init(named:"sep")
                smolS.clipsToBounds = true
                smolS.layer.cornerRadius = 1
                smolS.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
                nv.sep=smolS
            }
            mstr.addSubview(nv.sep)
            nv.sep.topAnchor.constraint(equalTo:mstr.topAnchor, constant:0).isActive=true
            nv.sep.trailingAnchor.constraint(equalTo: mstr.trailingAnchor, constant: 0).isActive=true
            
            mstr.heightAnchor.constraint(equalToConstant:CGFloat(cellhei)).isActive=true
            
            var subjlbl=UILabel()
            subjlbl.translatesAutoresizingMaskIntoConstraints=false
            subjlbl.text=curP!.subjs[ldobjs[i].ind].nm
            mstr.addSubview(subjlbl)
            subjlbl.font=UIFont.systemFont(ofSize:25)
            subjlbl.topAnchor.constraint(equalTo: mstr.topAnchor, constant: 15).isActive=true
            subjlbl.leadingAnchor.constraint(equalTo: mstr.leadingAnchor, constant: 10).isActive=true
            nv.subjlbl=subjlbl
            
            var lvlsel=UISegmentedControl()
            lvlsel.apportionsSegmentWidthsByContent=true
            lvlsel.translatesAutoresizingMaskIntoConstraints=false
            if (ldobjs[i].locc==loc.reg) {
                for j in 0..<curP!.subjs[ldobjs[i].ind].lvls.count {
                    lvlsel.insertSegment(withTitle: String(curP!.subjs[ldobjs[i].ind].lvls[j].name), at: j, animated: false)
                }
            }
            mstr.addSubview(lvlsel)
            lvlsel.selectedSegmentIndex=0
            lvlsel.topAnchor.constraint(equalTo: mstr.topAnchor, constant: 15).isActive=true
            nv.lvlsel=lvlsel
            lvlsel.addTarget(self, action: #selector(updtc), for:.valueChanged)
            
            var scsel=UISegmentedControl()
            scsel.apportionsSegmentWidthsByContent=true
            scsel.translatesAutoresizingMaskIntoConstraints=false
            for j in 0..<curP!.scds.count {
                scsel.insertSegment(withTitle: String(curP!.scds[j].sc), at: j, animated: false)
            }
            mstr.addSubview(scsel)
            scsel.selectedSegmentIndex=0
            scsel.topAnchor.constraint(equalTo: mstr.topAnchor, constant: 60).isActive=true
            nv.scsel=scsel
            scsel.addTarget(self, action: #selector(updtc), for:.valueChanged)
            
            vws.append(nv)
            if (i==0) {
                nv.sep.leadingAnchor.constraint(equalTo: stk.leadingAnchor).isActive=true
                nv.sep.trailingAnchor.constraint(equalTo: stk.trailingAnchor).isActive=true
            } else {
                nv.sep.leadingAnchor.constraint(equalTo: stk.leadingAnchor, constant: 20).isActive=true
                nv.sep.trailingAnchor.constraint(equalTo: stk.trailingAnchor).isActive=true
            }
            nv.scsel.trailingAnchor.constraint(equalTo: stk.trailingAnchor, constant:-10).isActive=true
            nv.scsel.leadingAnchor.constraint(equalTo: stk.leadingAnchor, constant:10).isActive=true
            nv.lvlsel.trailingAnchor.constraint(equalTo: stk.trailingAnchor, constant: -10).isActive=true
            nv.lvlsel.leadingAnchor.constraint(equalTo: stk.leadingAnchor, constant: 140).isActive=true
        }
        if doSave {
            updtc(segment: plcHldr)
        }
        var botBuf=UIView();
        botBuf.heightAnchor.constraint(equalToConstant: 10).isActive=true
        bottomPadding=botBuf
        stk.addArrangedSubview(botBuf)
    }
    // process: lstmx keeps track of transition item one and alphTr provides a way to keep track of tasks to cancel them
    var alphTr:[[DispatchWorkItem]]=[[]]
    var lstmax:[Int]=[] //lstsel: what was the last maximum
    var gradTr:[[DispatchWorkItem]]=[[]]
    var gradPos:[Double]=[]
    @objc func updtc(segment: UISegmentedControl) {
        print("-----GPA COMPUTE-----")
        assert(curP != nil,"Preset is nil while running evaluation!")
        saveData()
        if (segment != plcHldr) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            if (segment.titleForSegment(at: segment.selectedSegmentIndex) != nil) {
                if (segment.titleForSegment(at: segment.selectedSegmentIndex)! == "IB") {
                    for i in 0..<vws.count {
                        for j in 0..<vws[i].lvlsel.numberOfSegments {
                            if (vws[i].lvlsel.titleForSegment(at: j)=="IB") {
                                vws[i].lvlsel.selectedSegmentIndex=j
                            }
                        }
                    }
                }
            }
        }
        var ans=0.0
        var ttlCred=0.0
        var subjsen=curP!.enul()
        var tot=0
        var mxtot=0 //to keep track of the current maxsubj ID
        for i in 0..<subjsen.count {
            if (subjsen[i].locc == .reg) {
                print("Calculating for reg subject \(curP!.subjs[subjsen[i].ind].nm)")
                var bs=curP!.scds[vws[tot].scsel.selectedSegmentIndex].base-curP!.subjs[subjsen[i].ind].lvls[vws[tot].lvlsel.selectedSegmentIndex].offset
                bs=max(bs,0)
                print("Base \(bs)")
                bs*=curP!.subjs[subjsen[i].ind].lvls[vws[tot].lvlsel.selectedSegmentIndex].weight
                print("Weight \(curP!.subjs[subjsen[i].ind].lvls[vws[tot].lvlsel.selectedSegmentIndex].weight)")
                ans+=bs
                ttlCred+=curP!.subjs[subjsen[i].ind].lvls[vws[tot].lvlsel.selectedSegmentIndex].weight
                tot=tot+1
                print()
            } else {
                var selledInd=0
                var mstrBs = -10.0
                var selledtot=0
                var hasAP=false
                for j in 0..<curP!.mxSubs![subjsen[i].ind].subjs.count {
                    if curP!.mxSubs![subjsen[i].ind].subjs[j].lvls[vws[tot+j].lvlsel.selectedSegmentIndex].name=="AP" {
                        hasAP=true
                        break
                    }
                }
                for j in 0..<curP!.mxSubs![subjsen[i].ind].subjs.count {
                    if hasAP&&curP!.mxSubs![subjsen[i].ind].subjs[j].lvls[vws[tot].lvlsel.selectedSegmentIndex].name != "AP" {
                        tot=tot+1
                        mxtot=mxtot+1
                        continue
                    }
                    var bs=curP!.scds[vws[tot].scsel.selectedSegmentIndex].base-curP!.mxSubs![subjsen[i].ind].subjs[j].lvls[vws[tot].lvlsel.selectedSegmentIndex].offset
                    bs=max(bs,0)
                    bs*=curP!.mxSubs![subjsen[i].ind].subjs[j].lvls[vws[tot].lvlsel.selectedSegmentIndex].weight
                    if (mstrBs<bs&&abs(mstrBs-bs)>0.00001) {
                        mstrBs=bs
                        selledInd=j
                        selledtot=tot
                    }
                    tot=tot+1
                    mxtot=mxtot+1
                }
                mstrBs=max(mstrBs,0)
                ans+=mstrBs
                ttlCred+=curP!.mxSubs![subjsen[i].ind].subjs[selledInd].lvls[vws[selledtot].lvlsel.selectedSegmentIndex].weight
                let topC=17.0
                let botC=Double(cellhei*curP!.mxSubs![subjsen[i].ind].subjs.count-15)
                
                let offsetA=1.0/6
                let offsetB=1.0/2
                
                let coordlvl=Double(selledInd*cellhei)+Double(cellhei)/2.0
                let toptop=coordlvl-Double(cellhei)*(offsetA+offsetB)
                let topbot=coordlvl-Double(cellhei)*offsetA
                let bottop=coordlvl+Double(cellhei)*offsetA
                let botbot=coordlvl+Double(cellhei)*(offsetA+offsetB)
                
                if lstmax[subjsen[i].ind] == -1 {
                    for j in 0..<curP!.mxSubs![subjsen[i].ind].subjs.count {
                        if (j != selledInd) {
                            vws[tot-curP!.mxSubs![subjsen[i].ind].subjs.count+j].subjlbl.alpha=0
                        } else {
                            vws[tot-curP!.mxSubs![subjsen[i].ind].subjs.count+j].subjlbl.alpha=1
                        }
                    }
                    lstmax[subjsen[i].ind]=selledInd
                    var upgradMsk=UIView(frame: CGRect(x: 0,y: 0,width: 4,height: coordlvl-topC))
                    upgradMsk.backgroundColor = .black
                    gradPos[subjsen[i].ind]=coordlvl
                    lgradstop[subjsen[i].ind]!.mask=upgradMsk
                    lgradstop[subjsen[i].ind]!.startLocation=Double(toptop-topC)/Double(botC-topC)
                    lgradstop[subjsen[i].ind]!.endLocation=Double(topbot-topC)/Double(botC-topC)
                    lgradsbot[subjsen[i].ind]!.startLocation=Double(bottop-topC)/Double(botC-topC)
                    lgradsbot[subjsen[i].ind]!.endLocation=Double(botbot-topC)/Double(botC-topC)
                }
                if lstmax[subjsen[i].ind] != selledInd {
                    let alphaLstInd=mxtot-curP!.mxSubs![subjsen[i].ind].subjs.count+lstmax[subjsen[i].ind]
                    let vwsLstInd=tot-curP!.mxSubs![subjsen[i].ind].subjs.count+lstmax[subjsen[i].ind]
                    let alphaSelInd=mxtot-curP!.mxSubs![subjsen[i].ind].subjs.count+selledInd
                    let vwsSelInd=tot-curP!.mxSubs![subjsen[i].ind].subjs.count+selledInd
                                        
                    //cancel all animations on the last one
                    for j in 0..<alphTr[alphaLstInd].count {
                        alphTr[alphaLstInd][j].cancel()
                    }
                    alphTr[alphaLstInd].removeAll()
                    
                    //cancel all animations on the current one
                    for j in 0..<alphTr[mxtot-curP!.mxSubs![subjsen[i].ind].subjs.count+selledInd].count {
                        alphTr[alphaSelInd][j].cancel()
                    }
                    alphTr[alphaSelInd].removeAll()
                    
                    //animate selledInd to 100% opacity and lstmax to 0
                    
                    let fps=120.0
                    let totAdj=1.0
                    let totTime=0.3
                    
                    let stops=Int(fps*totTime)
                    let stopDur=totTime/Double(stops)
                    
                    //animate selledInd to 0%
                    var curOpa=Int(vws[vwsSelInd].subjlbl.alpha*CGFloat(stops))
                    
                    for j in curOpa...stops {
                        var wi=DispatchWorkItem(block: { [self] in
                            vws[vwsSelInd].subjlbl.alpha+=CGFloat(totAdj/Double(stops))
                        })
                        alphTr[alphaSelInd].append(wi)
                        DispatchQueue.main.asyncAfter(deadline: .now()+Double(j-curOpa)*stopDur, execute: wi)
                    }
                    
                    //animate lstmax to 100
                    curOpa=Int(vws[vwsLstInd].subjlbl.alpha*CGFloat(stops))
                    for j in 0...curOpa {
                        var wi=DispatchWorkItem(block: { [self] in
                            vws[vwsLstInd].subjlbl.alpha-=CGFloat(totAdj/Double(stops))
                        })
                        alphTr[alphaLstInd].append(wi)
                        DispatchQueue.main.asyncAfter(deadline: .now()+Double(j)*stopDur, execute: wi)
                    }
                    
                    //TODO: Update the gradient too
                    for j in 0..<gradTr[subjsen[i].ind].count {
                        gradTr[subjsen[i].ind][j].cancel()
                    }
                    let ttTime=0.4
                    let gradSpeed=Double(botC-topC)/ttTime //gradspeed - pixels/second
                    
                    // go to coordlvl
                    var stps=Int(ceil(Double(abs(gradPos[subjsen[i].ind]-coordlvl))/gradSpeed*fps))
                    for j in 0..<stps {
                        var wi=DispatchWorkItem(block: { [self] in
                            let toptopi=gradPos[subjsen[i].ind]-Double(cellhei)*(offsetA+offsetB)
                            let topboti=gradPos[subjsen[i].ind]-Double(cellhei)*offsetA
                            let bottopi=gradPos[subjsen[i].ind]+Double(cellhei)*offsetA
                            let botboti=gradPos[subjsen[i].ind]+Double(cellhei)*(offsetA+offsetB)
                            
                            var upgradMsk=UIView(frame: CGRect(x: 0,y: 0,width: 4,height: gradPos[subjsen[i].ind]-topC))
                            upgradMsk.backgroundColor = .black
                            lgradstop[subjsen[i].ind]!.mask=upgradMsk
                            lgradstop[subjsen[i].ind]!.startLocation=Double(toptopi-topC)/Double(botC-topC)
                            lgradstop[subjsen[i].ind]!.endLocation=Double(topboti-topC)/Double(botC-topC)
                            lgradsbot[subjsen[i].ind]!.startLocation=Double(bottopi-topC)/Double(botC-topC)
                            lgradsbot[subjsen[i].ind]!.endLocation=Double(botboti-topC)/Double(botC-topC)
                            
                            if (gradPos[subjsen[i].ind]<coordlvl) {
                                //go up
                                gradPos[subjsen[i].ind]=min(gradPos[subjsen[i].ind]+gradSpeed/fps,coordlvl)
                            } else {
                                gradPos[subjsen[i].ind]=max(gradPos[subjsen[i].ind]-gradSpeed/fps,coordlvl)
                            }
                        })
                        gradTr[subjsen[i].ind].append(wi)
                        DispatchQueue.main.asyncAfter(deadline: .now()+Double(j)*ttTime/fps, execute: wi)
                    }
                    
                    lstmax[subjsen[i].ind]=selledInd
                }
            }
        }
        if (ttlCred != 0) {
            ans/=ttlCred
        }
        var gpaDisp=String(Int(round(ans*1000)))
        while gpaDisp.count<4 {
            gpaDisp.insert("0", at: gpaDisp.startIndex)
        }
        res.text="Your GPA: "+gpaDisp[gpaDisp.startIndex..<gpaDisp.index(gpaDisp.endIndex, offsetBy: -3)]+"."+gpaDisp[gpaDisp.index(gpaDisp.endIndex, offsetBy: -3)..<gpaDisp.endIndex]
    }
    
}
