//
//  GameViewController.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/14/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SystemConfiguration
import Firebase




protocol GameSceneDelegate {
    func pushData(score: Int)
    func showAlert(withTitle title: String, message: String)
    func changeNameAlert(withTitle title: String, message: String)
    func presentLeaderboard()
    func setDelegate(sceneName: String, scene: GameViewControllerDelegate)
    func changeName(to: String)
    func adNoWorkAlert(withTitle title: String, message: String)
    func presentLocalAdView()
    func presentStore()
    func pushCoins(coins: Int)
    func getPlayerColor() -> UIColor
    func updateCheck()


}






//CHECKING INTERNET CONNECTION AND UPDATING PAST TASKS
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Only Working for WIFI
        //        let isReachable = flags == .reachable
        //        let needsConnection = flags == .connectionRequired
        //
        //        return isReachable && !needsConnection
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}






class GameViewController: UIViewController, GameSceneDelegate {

    
    
    
    var sceneDelegates = [String: GameViewControllerDelegate]()
    

    var adDissmissed: Bool = false
    
    var adValue = [String: Any]()
    //KEEP WORKING FROM HERE SET UP WITH USER DEFAULTS STORING WHICH OF THESE I OWN AND THEN ADD IT TO THE STOREVC
    var playerSkins = [
        [
            "name" : "default",
            "color": UIColor.cyan,
            "cost" : 0
        ],
        [
            "name" : "Red",
            "color" : UIColor.red,
            "cost" : 20
        ],
        [
            "name" : "Green",
            "color": UIColor.green,
            "cost" : 40
        ],
        [
            "name" : "Yellow",
            "color": UIColor.yellow,
            "cost" : 60
        ],
        [
            "name" : "Pink",
            "color": UIColor(red: 200/255, green: 0/255, blue: 200/255, alpha: 1.0),
            "cost" : 90
        ],
        [
            "name" : "Cool Blue",
            "color": UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            "cost" : 120
        ],
        [
            "name" : "Pumpkin",
            "color": UIColor(red: 211/255, green: 84/255, blue: 0/255, alpha: 1.0),
            "cost" : 300
        ],
        [
            "name" : "Gross",
            "color": UIColor(red: 125/255, green: 102/255, blue: 8/255, alpha: 1.0),
            "cost" : 400
        ],
        [
            "name" : "Purple",
            "color": UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0),
            "cost" : 600
        ],
        [
            "name" : "Mint",
            "color": UIColor(red: 88/255, green: 214/255, blue: 141/255, alpha: 1.0),
            "cost" : 800
        ],
        [
            "name" : "Pinkish",
            "color": UIColor(red: 253/255, green: 237/255, blue: 236/255, alpha: 1.0),
            "cost" : 900
        ]
        ] as [[String: Any]]
    
    
    //BANNED WORDS FROM FACEBOOK TO MAKE SURE NAME ISN'T PROFANE
    let badwords = ["2 girls 1 cup", "2g1c", "4r5e", "5h1t", "5hit", "a$$", "a$$hole", "a_s_s", "a2m", "a54", "a55", "a55hole", "acrotomophilia", "aeolus", "ahole", "alabama hot pocket", "alaskan pipeline", "anal", "anal impaler", "anal leakage", "analprobe", "anilingus", "anus", "apeshit", "ar5e", "areola", "areole", "arian", "arrse", "arse", "arsehole", "aryan", "ass", "ass fuck", "ass fuck", "ass hole" , "assbag", "assbandit", "assbang", "assbanged", "assbanger", "assbangs", "assbite", "assclown", "asscock", "asscracker", "asses", "assface", "assfaces", "assfuck", "assfucker", "ass-fucker", "assfukka", "assgoblin", "assh0le", "asshat", "ass-hat", "asshead", "assho1e", "asshole", "assholes", "asshopper", "ass-jabber", "assjacker", "asslick", "asslicker", "assmaster", "assmonkey", "assmucus", "assmucus", "assmunch", "assmuncher", "assnigger", "asspirate", "ass-pirate", "assshit", "assshole", "asssucker", "asswad", "asswhole", "asswipe", "asswipes", "auto erotic", "autoerotic", "axwound", "azazel", "azz", "b!tch", "b00bs", "b17ch", "b1tch", "babeland", "baby batter", "baby juice", "ball gag", "ball gravy", "ball kicking", "ball licking", "ball sack", "ball sucking", "ballbag", "balls", "ballsack", "bampot", "bang (one's) box", "bangbros", "bareback", "barely legal", "barenaked", "barf", "bastard", "bastardo", "bastards", "bastinado", "batty boy", "bawdy", "bbw", "bdsm", "beaner", "beaners", "beardedclam", "beastial", "beastiality", "beatch", "beaver", "beaver cleaver", "beaver lips", "beef curtain", "beef curtain", "beef curtains", "beeyotch", "bellend", "bender", "beotch", "bescumber", "bestial", "bestiality", "bi+ch", "biatch", "big black", "big breasts", "big knockers", "big tits", "bigtits, bimbo", "bimbos", "bint", "birdlock", "bitch", "bitch tit", "bitch tit", "bitchass", "bitched", "bitcher", "bitchers", "bitches", "bitchin", "bitching", "bitchtits", "bitchy", "black cock", "blonde action", "blonde on blonde action", "bloodclaat", "bloody", "bloody hell", "blow job", "blow me", "blow mud", "blow your load", "blowjob", "blowjobs", "blue waffle", "blue waffle", "blumpkin", "blumpkin", "bod", "bodily", "boink", "boiolas", "bollock", "bollocks", "bollok", "bollox", "bondage", "boned", "boner", "boners", "bong", "boob", "boobies", "boobs", "booby", "booger", "bookie", "boong", "booobs", "boooobs", "booooobs", "booooooobs", "bootee", "bootie", "booty", "booty call", "booze", "boozer", "boozy", "bosom", "bosomy", "breasts", "Breeder", "brotherfucker", "brown showers", "brunette action", "bugger", "bukkake", "bull shit", "bulldyke", "bullet vibe", "bullshit", "bullshits", "bullshitted", "bullturds", "bum", "bum boy", "bumblefuck", "bumclat", "bummer", "buncombe", "bung", "bung hole", "bunghole", "bunny fucker", "bust a load", "bust a load", "busty", "butt", "butt fuck", "butt fuck", "butt plug", "buttcheeks", "buttfuck", "buttfucka", "buttfucker", "butthole", "buttmuch", "buttmunch", "butt-pirate", "buttplug", "c.0.c.k", "c.o.c.k.", "c.u.n.t", "c0ck", "c-0-c-k", "c0cksucker", "caca", "cacafuego", "cahone", "camel", "toe", "cameltoe", "camgirl", "camslut", "camwhore", "carpet muncher", "carpetmuncher", "cawk", "cervix", "chesticle", "chi-chi man", "chick with a dick", "child-fucker", "chinc", "chincs", "chink", "chinky", "choad", "choade", "choade", "choc ice", "chocolate rosebuds", "chode", "chodes", "chota bags", "chota bags", "cipa", "circlejerk", "cl1t", "cleveland steamer", "climax", "clit", "clit licker", "clit licker", "clitface", "clitfuck", "clitoris", "clitorus", "clits", "clitty", "clitty litter", "clitty litter", "clover clamps", "clunge", "clusterfuck", "cnut", "cocain", "cocaine", "coccydynia", "cock", "c-o-c-k", "cock pocket", "cock pocket", "cock snot", "cock snot", "cock sucker", "cockass", "cockbite", "cockblock", "cockburger", "cockeye", "cockface", "cockfucker", "cockhead", "cockholster", "cockjockey", "cockknocker", "cockknoker", "Cocklump", "cockmaster", "cockmongler", "cockmongruel", "cockmonkey", "cockmunch", "cockmuncher", "cocknose", "cocknugget", "cocks", "cockshit", "cocksmith", "cocksmoke", "cocksmoker", "cocksniffer", "cocksuck", "cocksuck", "cocksucked", "cocksucked", "cocksucker", "cock-sucker", "cocksuckers", "cocksucking", "cocksucks", "cocksucks", "cocksuka", "cocksukka", "cockwaffle", "coffin dodger", "coital", "cok", "cokmuncher", "coksucka", "commie", "condom", "coochie", "coochy", "coon", "coonnass", "coons", "cooter", "cop some wood", "cop some wood", "coprolagnia", "coprophilia", "corksucker", "cornhole", "cornhole", "corp whore", "corp whore", "corpulent", "cox", "crabs", "crack", "cracker", "crackwhore", "crap", "crappy", "creampie", "cretin", "crikey", "cripple", "crotte", "cum", "cum", "chugger", "cum chugger", "cum dumpster", "cum dumpster", "cum freak", "cum freak", "cum guzzler", "cum guzzler", "cumbubble", "cumdump", "cumdump", "cumdumpster", "cumguzzler", "cumjockey", "cummer", "cummin", "cumming", "cums", "cumshot", "cumshots", "cumslut", "cumstain", "cumtart", "cunilingus", "cunillingus", "cunnie", "cunnilingus", "cunny", "cunt", "c-u-n-t", "cunt hair", "cunt hair", "cuntass", "cuntbag", "cuntbag", "cuntface", "cunthole", "cunthunter", "cuntlick", "cuntlick", "cuntlicker", "cuntlicker", "cuntlicking", "cuntlicking", "cuntrag", "cunts", "cuntsicle", "cuntsicle", "cuntslut", "cunt-struck", "cunt-struck", "cus", "cut rope", "cut rope", "cyalis", "cyberfuc", "cyberfuck", "cyberfuck", "cyberfucked", "cyberfucked", "cyberfucker", "cyberfuckers", "cyberfucking", "cyberfucking", "d0ng", "d0uch3", "d0uche", "d1ck", "d1ld0", "d1ldo", "dago", "dagos", "dammit", "damn", "damned", "damnit", "darkie", "darn", "date rape", "daterape", "dawgie-style", "deep throat", "deepthroat", "deggo", "dendrophilia", "dick", "dick head", "dick hole", "dick hole", "dick shy", "dick shy", "dickbag", "dickbeaters", "dickdipper", "dickface", "dickflipper", "dickfuck", "dickfucker", "dickhead", "dickheads", "dickhole", "dickish", "dick-ish", "dickjuice", "dickmilk", "dickmonger", "dickripper", "dicks", "dicksipper", "dickslap", "dick-sneeze", "dicksucker", "dicksucking", "dicktickler", "dickwad", "dickweasel", "dickweed", "dickwhipper", "dickwod", "dickzipper", "diddle", "dike", "dildo", "dildos", "diligaf", "dillweed", "dimwit", "dingle", "dingleberries", "dingleberry", "dink", "dinks", "dipship", "dipshit", "dirsa", "dirty", "dirty pillows", "dirty sanchez", "dirty Sanchez", "div", "dlck", "dog style", "dog-fucker", "doggie style", "doggiestyle", "doggie-style", "doggin", "dogging", "doggy style", "doggystyle", "doggy-style", "dolcett", "domination", "dominatrix", "dommes", "dong", "donkey punch", "donkeypunch", "donkeyribber", "doochbag", "doofus", "dookie", "doosh", "dopey", "double dong", "double penetration", "Doublelift", "douch3", "douche", "douchebag", "douchebags", "douche-fag", "douchewaffle", "douchey", "dp action", "drunk", "dry hump", "duche", "dumass", "dumb ass", "dumbass", "dumbasses", "Dumbcunt", "dumbfuck", "dumbshit", "dummy", "dumshit", "dvda", "dyke", "dykes", "eat a dick", "eat a dick", "eat hair pie", "eat hair pie", "eat my ass", "ecchi", "ejaculate", "ejaculated", "ejaculates", "ejaculates", "ejaculating", "ejaculating", "ejaculatings", "ejaculation", "ejakulate", "erect", "erection", "erotic", "erotism", "escort", "essohbee", "eunuch", "extacy", "extasy", "f u c k", "f u c k e r", "f.u.c.k", "f_u_c_k", "f4nny", "facial", "fack", "fag", "fagbag", "fagfucker", "fagg", "fagged", "fagging", "faggit", "faggitt", "faggot", "faggotcock", "faggots", "faggs", "fagot", "fagots", "fags", "fagtard", "faig", "faigt", "fanny", "fannybandit", "fannyflaps", "fannyfucker", "fanyy", "fart", "fartknocker", "fatass", "fcuk", "fcuker", "fcuking", "fecal", "feck", "fecker", "feist", "felch", "felcher", "felching", "fellate", "fellatio", "feltch", "feltcher", "female squirting", "femdom", "fenian", "fice", "figging", "fingerbang", "fingerfuck", "fingerfuck", "fingerfucked", "fingerfucked", "fingerfucker", "fingerfucker", "fingerfuckers", "fingerfucking", "fingerfucking", "fingerfucks", "fingerfucks", "fingering", "fist fuck", "fist fuck", "fisted", "fistfuck", "fistfucked", "fistfucked", "fistfucker", "fistfucker", "fistfuckers", "fistfuckers", "fistfucking", "fistfucking", "fistfuckings", "fistfuckings", "fistfucks", "fistfucks", "fisting", "fisty", "flamer", "flange", "flaps", "fleshflute", "flog the log", "flog the log", "floozy", "foad", "foah", "fondle", "foobar", "fook", "fooker", "foot fetish", "footjob", "foreskin", "freex", "frenchify", "frigg", "frigga", "frotting", "fubar", "fuc", "fuck", "fuck", "f-u-c-k", "fuck buttons", "fuck hole", "fuck hole", "Fuck off", "fuck puppet", "fuck puppet", "fuck trophy", "fuck trophy", "fuck yo mama", "fuck yo mama", "fuck you", "fucka", "fuckass", "fuck-ass", "fuck-ass", "fuckbag", "fuck-bitch", "fuck-bitch", "fuckboy", "fuckbrain", "fuckbutt", "fuckbutter", "fucked", "fuckedup", "fucker", "fuckers", "fuckersucker", "fuckface", "fuckhead", "fuckheads", "fuckhole", "fuckin", "fucking", "fuckings", "fuckingshitmotherfucker", "fuckme", "fuckme", "fuckmeat", "fuckmeat", "fucknugget", "fucknut", "fucknutt", "fuckoff", "fucks", "fuckstick", "fucktard", "fuck-tard", "fucktards", "fucktart", "fucktoy", "fucktoy", "fucktwat", "fuckup", "fuckwad", "fuckwhit", "fuckwit", "fuckwitt", "fudge packer", "fudgepacker", "fudge-packer", "fuk", "fuker", "fukker", "fukkers", "fukkin", "fuks", "fukwhit", "fukwit", "fuq", "futanari", "fux", "fux0r", "fvck", "fxck", "gae", "gai", "gang bang", "gangbang", "gang-bang", "gang-bang", "gangbanged", "gangbangs", "ganja", "gash", "gassy ass", "gassy ass", "gay", "gay sex", "gayass", "gaybob", "gaydo", "gayfuck", "gayfuckist", "gaylord", "gays", "gaysex", "gaytard", "gaywad", "gender bender", "genitals", "gey", "gfy", "ghay", "ghey", "giant cock", "gigolo", "ginger", "gippo", "girl on", "girl on top", "girls gone wild", "git", "glans", "goatcx", "goatse", "god", "god damn", "godamn", "godamnit", "goddam", "god-dam", "goddammit", "goddamn", "goddamned", "god-damned", "goddamnit", "godsdamn", "gokkun", "golden shower", "goldenshower", "golliwog", "gonad", "gonads", "goo girl", "gooch", "goodpoop", "gook", "gooks", "goregasm", "gringo", "grope", "group sex", "gspot", "g-spot", "gtfo", "guido", "guro", "h0m0", "h0mo", "ham flap", "ham flap", "hand job", "handjob", "hard core", "hard on, hardcore", "hardcoresex", "he11", "hebe", "heeb", "hell", "hemp", "hentai", "heroin", "herp", "herpes", "herpy", "heshe", "he-she", "hircismus", "hitler", "hiv", "ho", "hoar", "hoare", "hobag", "hoe", "hoer", "holy shit", "hom0", "homey", "homo", "homodumbshit", "homoerotic", "homoey", "honkey", "honky", "hooch", "hookah", "hooker", "hoor", "hootch", "hooter", "hooters", "hore", "horniest", "horny", "hot carl", "hot chick", "hotsex", "how to kill", "how to murdep", "how to murder", "huge fat", "hump", "humped", "humping", "hun", "hussy", "hymen", "iap", "iberian slap", "inbred", "incest", "injun", "intercourse", "jack off", "jackass", "jackasses", "jackhole", "jackoff", "jack-off", "jaggi", "jagoff", "jail bait", "jailbait", "jap", "japs", "jelly donut", "jerk", "jerk off", "jerk0ff", "jerkass", "jerked", "jerkoff", "jerk-off", "jigaboo", "jiggaboo", "jiggerboo", "jism", "jiz", "jiz", "jizm", "jizm", "jizz", "jizzed", "jock", "juggs", "jungle bunny", "junglebunny", "junkie", "junky", "kafir", "kawk", "kike", "kikes", "kill", "kinbaku", "kinkster", "kinky", "klan", "knob", "knob end", "knobbing", "knobead", "knobed", "knobend", "knobhead", "knobjocky", "knobjokey", "kock", "kondum", "kondums", "kooch", "kooches", "kootch", "kraut", "kum", "kummer", "kumming", "kums", "kunilingus", "kunja", "kunt", "kwif", "kwif", "kyke", "l3i+ch", "l3itch", "labia", "lameass", "lardass", "leather restraint", "leather straight jacket", "lech", "lemon party", "LEN", "leper", "lesbian", "lesbians", "lesbo", "lesbos", "lez", "lezza/lesbo", "lezzie", "lmao", "lmfao", "loin", "loins", "lolita", "looney", "lovemaking", "lube", "lust", "lusting", "lusty", "m0f0", "m0fo", "m45terbate", "ma5terb8", "ma5terbate", "mafugly", "mafugly", "make me come", "male squirting", "mams", "masochist", "massa", "masterb8", "masterbat", "masterbat3", "masterbate", "master-bate", "master-bate", "masterbating", "masterbation", "masterbations", "masturbate", "masturbating", "masturbation", "maxi", "mcfagget", "menage a trois", "menses", "menstruate", "menstruation", "meth", "m-fucking", "mick", "microphallus", "middle finger", "midget", "milf", "minge", "minger", "missionary position", "mof0", "mofo", "mo-fo", "molest", "mong", "moo moo foo foo", "moolie", "moron", "mothafuck", "mothafucka", "mothafuckas", "mothafuckaz", "mothafucked", "mothafucked", "mothafucker", "mothafuckers", "mothafuckin", "mothafucking", "mothafucking", "mothafuckings", "mothafucks", "mother fucker", "mother fucker", "motherfuck", "motherfucka", "motherfucked", "motherfucker", "motherfuckers", "motherfuckin", "motherfucking", "motherfuckings", "motherfuckka", "motherfucks", "mound of venus", "mr hands", "muff", "muff diver", "muff puff", "muff puff", "muffdiver", "muffdiving", "munging", "munter", "murder", "mutha", "muthafecker", "muthafuckker", "muther", "mutherfucker", "n1gga", "n1gger", "naked", "nambla", "napalm", "nappy", "nawashi", "nazi", "nazism", "need the dick", "need the dick", "negro", "neonazi", "nig nog", "nigaboo", "nigg3r", "nigg4h", "nigga", "niggah", "niggas", "niggaz", "nigger", "niggers", "niggle", "niglet", "nig-nog", "nimphomania", "nimrod", "ninny", "ninnyhammer", "nipple", "nipples", "nob", "nob jokey", "nobhead", "nobjocky", "nobjokey", "nonce", "nsfw images", "nude", "nudity", "numbnuts", "nut butter", "nut butter", "nut sack", "nutsack", "nutter", "nympho", "nymphomania", "octopussy", "old bag", "omg", "omorashi", "one cup two girls", "one guy one jar", "opiate", "opium", "orally", "organ", "orgasim", "orgasims", "orgasm", "orgasmic", "orgasms", "orgies", "orgy", "ovary", "ovum", "ovums", "p.u.s.s.y.", "p0rn", "paedophile", "paki", "panooch", "pansy", "pantie", "panties", "panty", "pawn", "pcp", "pecker", "peckerhead", "pedo", "pedobear", "pedophile", "pedophilia", "pedophiliac", "pee", "peepee", "pegging", "penetrate", "penetration", "penial", "penile", "penis", "penisbanger", "penisfucker", "penispuffer", "perversion", "phallic", "phone sex", "phonesex", "phuck", "phuk", "phuked", "phuking", "phukked", "phukking", "phuks", "phuq", "piece of shit", "pigfucker", "pikey", "pillowbiter", "pimp", "pimpis", "pinko", "piss", "piss off", "piss pig", "pissed", "pissed off", "pisser", "pissers", "pisses", "pisses", "pissflaps", "pissin", "pissin", "pissing", "pissoff", "pissoff", "piss-off", "pisspig", "playboy", "pleasure chest", "pms", "polack", "pole smoker", "polesmoker", "pollock", "ponyplay", "poof", "poon", "poonani", "poonany", "poontang", "poop", "poop chute", "poopchute", "Poopuncher", "porch monkey", "porchmonkey", "porn", "porno", "pornography", "pornos", "pot", "potty", "prick", "pricks", "prickteaser", "prig", "prince albert piercing", "prod", "pron", "prostitute", "prude", "psycho", "pthc", "pube", "pubes", "pubic", "pubis", "punani", "punanny", "punany", "punkass", "punky", "punta", "puss", "pusse", "pussi", "pussies", "pussy", "pussy fart", "pussy fart", "pussy palace", "pussy palace", "pussylicking", "pussypounder", "pussys", "pust", "puto", "queaf", "queaf", "queef", "queer", "queerbait", "queerhole", "queero", "queers", "quicky", "quim", "racy", "raghead", "raging boner", "rape", "raped", "raper", "rapey", "raping", "rapist", "raunch", "rectal", "rectum", "rectus", "reefer", "reetard", "reich", "renob", "retard", "retarded", "reverse cowgirl", "revue", "rimjaw", "rimjob", "rimming", "ritard", "rosy palm", "rosy palm and her 5 sisters", "rtard", "r-tard", "rubbish", "rum", "rump", "rumprammer", "ruski", "rusty trombone", "s hit", "s&m", "s.h.i.t.", "s.o.b.", "s_h_i_t", "s0b", "sadism", "sadist", "sambo", "sand nigger", "sandbar", "sandbar", "Sandler", "sandnigger", "sanger", "santorum", "sausage queen", "sausage queen", "scag", "scantily", "scat", "schizo", "schlong", "scissoring", "screw", "screwed", "screwing", "scroat", "scrog", "scrot", "scrote", "scrotum", "scrud", "scum", "seaman", "seamen", "seduce", "seks", "semen", "sex", "sexo", "sexual", "sexy", "sh!+", "sh!t", "sh1t", "s-h-1-t", "shag", "shagger", "shaggin", "shagging", "shamedame", "shaved beaver", "shaved pussy", "shemale", "shi+", "shibari", "shirt lifter", "shit", "s-h-i-t", "shit ass", "shit fucker", "shit fucker", "shitass", "shitbag", "shitbagger", "shitblimp", "shitbrains", "shitbreath", "shitcanned", "shitcunt", "shitdick", "shite", "shiteater", "shited", "shitey", "shitface", "shitfaced", "shitfuck", "shitfull", "shithead", "shitheads", "shithole", "shithouse", "shiting", "shitings", "shits", "shitspitter", "shitstain", "shitt", "shitted", "shitter", "shitters", "shitters", "shittier", "shittiest", "shitting", "shittings", "shitty", "shiz", "shiznit", "shota", "shrimping", "sissy", "skag", "skank", "skeet", "skullfuck", "slag", "slanteye", "slave", "sleaze", "sleazy", "slope", "slope", "slut", "slut bucket", "slut bucket", "slutbag", "slutdumper", "slutkiss", "sluts", "smartass", "smartasses", "smeg", "smegma", "smut", "smutty", "snatch", "sniper", "snowballing", "snuff", "s-o-b", "sod off", "sodom", "sodomize", "sodomy", "son of a bitch", "son of a motherless goat", "son of a whore", "son-of-a-bitch", "souse", "soused", "spac", "spade", "sperm", "spic", "spick", "spik", "spiks", "splooge", "splooge moose", "spooge", "spook", "spread legs", "spunk", "stfu", "stiffy", "stoned", "strap on", "strapon", "strappado", "strip", "strip club", "stroke", "stupid", "style doggy", "suck", "suckass", "sucked", "sucking", "sucks", "suicide girls", "sultry women", "sumofabiatch", "swastika", "swinger, t1t", "t1tt1e5", "t1tties", "taff", "taig", "tainted love", "taking the piss", "tampon", "tard", "tart", "taste my", "tawdry", "tea bagging", "teabagging", "teat", "teets", "teez", "teste", "testee", "testes", "testical", "testicle", "testis", "threesome", "throating", "thrust", "thug", "thundercunt", "tied up", "tight white", "tinkle", "tit", "tit wank", "tit wank", "titfuck", "titi", "tities", "tits", "titt", "tittie5", "tittiefucker", "titties", "titty", "tittyfuck", "tittyfucker", "tittywank", "titwank", "toke", "tongue in a", "toots", "topless", "tosser", "towelhead", "tramp", "tranny", "transsexual", "trashy", "tribadism", "trumped", "tub girl", "tubgirl", "turd", "tush", "tushy", "tw4t", "twat", "twathead", "twatlips", "twats", "twatty", "twatwaffle", "twink", "twinkie", "two fingers", "two fingers with tongue", "two girls one cup", "twunt", "twunter", "ugly", "unclefucker", "undies", "undressing", "unwed", "upskirt", "urethra play", "urinal", "urine", "urophilia", "uterus", "uzi", "v14gra", "v1gra", "vag", "vagina", "vajayjay", "va-j-j", "valium", "venus mound", "veqtable", "viagra", "vibrator", "violet wand", "virgin", "vixen", "vjayjay", "vodka", "vomit", "vorarephilia", "voyeur", "vulgar", "vulva", "w00se", "wad", "wang", "wank", "wanker", "wankjob", "wanky", "wazoo", "wedgie", "weed", "weenie", "weewee", "weiner", "weirdo", "wench", "wet dream", "wetback", "wh0re", "wh0reface", "white power", "whiz", "whoar", "whoralicious", "whore", "whorealicious", "whorebag", "whored", "whoreface", "whorehopper", "whorehouse", "whores", "whoring", "wigger", "willies", "willy", "window licker", "wiseass", "wiseasses", "wog", "womb", "wop", "wrapping men", "wrinkled starfish", "wtf", "xrated", "x-rated", "xx", "xxx", "yaoi", "yeasty", "yellow showers", "yid", "yiffy", "yobbo", "zibbi", "zoophilia", "zubb"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults().integer(forKey: "myID") == 0 {
            
            UserDefaults().set(0, forKey: "highScore")
            UserDefaults().set(arc4random(), forKey: "myID")
            
        }else{
            print("peep here")
            if Reachability.isConnectedToNetwork() {
                checkforDataChanges()
            }
        }
        
        
//        interstitial = createAndLoadInterstitial()
//        interstitial.delegate = self
        
        if let view = self.view as! SKView? {
            
            
            let scene = GameStartScene(size: view.frame.size)
            scene.mydelegate = self

            
            // Set the scale mode to scale to fit the window
            
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true

        }
        
        //THIS LOADS IN THE LOCAL AD DATA THAT WILL BE USED WHEN THE PLAYER DIES
        Database.database().reference().child("ads").observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.adValue = snapshot.value as! [String: Any]
            print(snapshot.value as! [String: Any])
            
            
        })
        
    }
    
    
    func checkforDataChanges() {
        let id = UserDefaults().integer(forKey: "myID")
        var isNormal = true
        Database.database().reference().child("isNormal").observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value != nil){
                isNormal = (snapshot.value != nil)
            }
        })
        
        Database.database().reference().child("users").child("\(id)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            if value?["name"] != nil {
                UserDefaults().set(value!["name"], forKey: "name")
            }
            if value?["highScore"] != nil {
                if isNormal && value!["highScore"] as! Int  > UserDefaults().integer(forKey: "highScore"){
                    UserDefaults().set(value!["highScore"], forKey: "highScore")
                }
                if !isNormal {
                    UserDefaults().set(value!["highScore"], forKey: "highScore")
                }
            }
            if value?["coins"] != nil {
                if isNormal && value!["coins"] as! Int  > UserDefaults().integer(forKey: "coins"){
                    UserDefaults().set(value!["coins"], forKey: "coins")
                }
                if !isNormal {
                    UserDefaults().set(value!["coins"], forKey: "coins")
                }

            }
            
        })
    }
    
    func pushData(score: Int) {
        
        if Reachability.isConnectedToNetwork(){
            let id = UserDefaults().integer(forKey: "myID")
            var completed = false
            Database.database().reference().child("users").child("\(id)").child("highScore").setValue(score) { (error, ref) in
                if error != nil {
                    UserDefaults().set(true, forKey: "shouldUpdateHighScore")
                } else {
                    completed = true
                    UserDefaults().set(false, forKey: "shouldUpdateHighScore")
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                if !completed {
                    UserDefaults().set(false, forKey: "shouldUpdateHighScore")
                }
            })
        } else {
            UserDefaults().set(true, forKey: "shouldUpdateHighScore")
        }
        
    }
    
    func pushCoins(coins: Int) {
        
        if Reachability.isConnectedToNetwork() {
            let id = UserDefaults().integer(forKey: "myID")
            Database.database().reference().child("users").child("\(id)").child("coins").setValue(UserDefaults().integer(forKey: "coins"))
            
        }

        
    }
    
    func setDelegate(sceneName: String, scene: GameViewControllerDelegate) {
        self.sceneDelegates[sceneName] = scene
    }
    
    

    
    func showAlert(withTitle title: String, message: String) {
        
        //instantiates alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //adds textfield and sets plac eholder
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter your name"
            
            //instantiates uialertaction
            let action = UIAlertAction(title: "OK", style: .default) { (alertaction) in

                self.changeName(to: textField.text!)

                    self.sceneDelegates["GameOverScene"]!.trigger()

                alertController.dismiss(animated: true, completion: nil)

            }
            
            //adds action
            alertController.addAction(action)
        }
        
        //presents alert controller on top of view controller
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    
    //CHANGES NAME TO A NEW ONE
    //CALLED FROM CHANGE NAME ALERT WHEN VALID NAME IS SUBMITTED
    func changeName(to: String) {
        
        
        
        if Reachability.isConnectedToNetwork(){
            UserDefaults().set(to, forKey: "name")
            let id = UserDefaults().integer(forKey: "myID")
            // var completed = false
            Database.database().reference().child("users").child("\(id)").child("name").setValue(to) { (error, ref) in
                if error == nil {
                    //completed = true
                    UserDefaults().set(false, forKey: "shouldUpdateName")
                } else {
                    UserDefaults().set(true, forKey: "shouldUpdateName")
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                UserDefaults().set(true, forKey: "shouldUpdateName")
            })
        } else {
            self.adNoWorkAlert(withTitle: "No Internet", message: "Connect to internet to change your name")
        }
        
        if let del = sceneDelegates["GameStartScene"] {
            del.reloadName()
        }
    }
    

    
    func getPlayerColor() -> UIColor {
        if UserDefaults().string(forKey: "selected") == nil {
            UserDefaults().set("\(playerSkins[0]["name"] as! String)", forKey: "selected")
        }
        var selectedColor = UIColor.cyan
        let selectedState = UserDefaults().string(forKey: "selected")
        for skin in playerSkins {
            if selectedState == skin["name"] as? String {
                selectedColor = (skin["color"] as? UIColor)!
            }
        }
        return selectedColor
    }
    
    
    //PRESENTS ALERT TO CHANGE NAME FROM CURRENT NAME TO A NEW NAME
    //CALLED FROM STARTGAME SCENE WHEN USER PRESSES CHANGE NAME BUTTON
    func changeNameAlert(withTitle title: String, message: String) {
        //instantiates alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //adds text field to alert controller and sets placeholder text
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter your name"
            
            let cancelaction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(cancelaction)
            
            //instantiates action
            let action = UIAlertAction(title: "OK", style: .default) { (alertaction) in
                
                //if name is valid, sets it in database and user defaults, otherwise presents new alert telling you invalid name
                if self.validateName(name: textField.text!) {
                    self.changeName(to: textField.text!)
                    UserDefaults().set(textField.text!, forKey: "name")
                    
                    alertController.dismiss(animated: true, completion: nil)
                } else {
                    self.changeNameAlert(withTitle: "Invalid Name", message: "Name may have been too long or otherwise deemed invalid.  Try again.")
                }
            }
            //adds the action to the alert
            alertController.addAction(action)
        }
        
        //presents the alert on top of the view controller
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    //DETERMINES WHETHER NAME PASSES PROFANITY AND LENGTH REQUIREMENTS
    //CALLED FROM ALERT FUNCTIONS EACH TIME NAME IS SET TO DETERMINE VALIDITY
    func validateName(name: String) -> Bool {
        var badwordbool = false
        for word in badwords {
            if name.lowercased().range(of: word) != nil {
                badwordbool = true
                break
            }
        }
        let lengthOk = name.count > 1 && name.count < 13
        var str = ""
        for _ in name {
            str = str + " "
        }
        let spaceBool = name.range(of: str) == nil
        return lengthOk && spaceBool && !badwordbool
    }
    
   
    
    func updateCheck(){
        
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            Database.database().reference().child("deprecatedVersions").observeSingleEvent(of: .value, with: { (snapshot) in
                // completed = true
                //STORE DATABASE VALUE IN DATA CONSTANT
                if let data = snapshot.value as? String {
                    print("DATA FOUND")
                    print(data)
                    if data.range(of: appVersion as! String) != nil {
                        print(data)
                        //IF AN UPDATE IS NECESSARY PRESENT THE UPDATE ALERT
                        self.presentUpdateAlert()
                    }
                    
                }
            })
            
        }
        
    }
    
    
    
    func presentUpdateAlert() {
        let alertController = UIAlertController(title: "Update App", message: "Update this app in the app store.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Update", style: .default) { (alertaction) in
            guard let url = URL(string: "https://apps.apple.com/us/app/skizn/id1329142052") else { return }
            UIApplication.shared.open(url)
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    
    
    func presentLeaderboard() {
        
        
        var value = [String: Any]()
        var completed = false
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            completed = true
            value = snapshot.value as! [String: Any]
            self.performSegue(withIdentifier: "toLeaderboard", sender: value)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            if !completed {
                self.adNoWorkAlert(withTitle: "No Internet", message: "Connect to internet to see leaderboard.")
            }
        })
        
    }
    
    func presentStore() {
        var completed = false
        if Reachability.isConnectedToNetwork() {
            completed = true
            self.performSegue(withIdentifier: "toStore", sender: playerSkins)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            if !completed {
                self.adNoWorkAlert(withTitle: "No Internet", message: "Connect to internet to access the store")
            }
        })
        
    }
    
    
    func adNoWorkAlert(withTitle title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alertaction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        view?.window?.rootViewController?.present(alertController, animated: true)
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewVC {
            destination.cellData = sender as? [String: Any]
        }
        if let destination = segue.destination as? LocalAdVC {
            destination.adData = (sender as? [String: Any])!
        }
        if let destination = segue.destination as? StoreVC {
            destination.playerData = sender as? [[String: Any]]
        }
    }
    

    
   
    
    func presentLocalAdView() {
        if Reachability.isConnectedToNetwork(){
            self.performSegue(withIdentifier: "toLocalAd", sender: adValue)
        }
    }

    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}



