//
//  ViewController.swift
//  Blackjack
//
//  Created by 蔡佳穎 on 2021/5/29.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var communicateLabel: UILabel!
    @IBOutlet weak var totalBetLabel: UILabel!
    @IBOutlet weak var chipView: UIView!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var betView: UIView!
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var pcScoreView: UIView!
    @IBOutlet weak var playerScoreView: UIView!
    @IBOutlet weak var pcScoreLabel: UILabel!
    @IBOutlet weak var playerScoreLabel:
        UILabel!
    @IBOutlet weak var playerResultView: UIView!
    @IBOutlet weak var playerResultLabel: UILabel!
    @IBOutlet weak var pcResultView: UIView!
    @IBOutlet weak var pcResultLabel: UILabel!
    
    @IBOutlet var playerCardImageViews: [UIImageView]!
    @IBOutlet var pcCardImageViews: [UIImageView]!
    
    @IBOutlet weak var betBtn: UIButton!
    @IBOutlet weak var hitBtn: UIButton!
    @IBOutlet weak var standBtn: UIButton!
    @IBOutlet weak var nextRoundBtn: UIButton!
    
    var bet = 0
    var totalBet = 12000
    let Suits = ["club_", "diamond_", "heart_", "spade_"]
    let ranks = ["a", "2", "3", "4", "5", "6", "7", "8", "9", "10", "j", "q", "k"]
    var playerCards = [Card]()
    var pcCards = [Card]()
    var playerCardIndex = 2
    
    var playerTotalScore = 0
    var pcTotalScore = 0
    var playerACount = 0
    var pcACount = 0

    var playerSmallAScore = 0
    var playerBigAScore = 0
    var playerAScore = 0
    var pcAScore = 0
    var pcBlackjack: Bool = false
    
    func creatCard() {
        for suit in Suits {
            for rank in ranks {
                let card = Card(suit: suit, rank: rank)
                playerCards.append(card)
            }
        }
        for suit in Suits {
            for rank in ranks {
                let card = Card(suit: suit, rank: rank)
                pcCards.append(card)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatCard()
        playerCards.shuffle()
        pcCards.shuffle()
        betBtn.isEnabled = true
        chipView.isHidden = true
        betView.isHidden = true
        pcScoreView.isHidden = true
        playerScoreView.isHidden = true
        playerResultView.isHidden = true
        pcResultView.isHidden = true
    }
    
    func showBetLabel() {
        betLabel.text = "\(bet)"
        betLabel.sizeToFit()
        totalBet -= bet
        totalBetLabel.text = "\(totalBet)"
        totalBetLabel.sizeToFit()
        communicateLabel.text = ""
        chipView.isHidden = false
    }
    
    //計算除了A以外的score，未存至total
    func getRankScore(rank: String) -> Int {
        var score = 0
        if rank == "j" || rank == "q" || rank == "k" {
            score = 10
        } else {
            if Int(rank) != nil {
                score = Int(rank)!
            }
        }
        return score
    }

    //判斷玩家小A或大A
    func decidePlayerSmallOrBigA(smallAScore: Int, bigAScore: Int) -> (score: Int, scoreLabel: String) {
        var score = 0
        if playerTotalScore + smallAScore == 21 {
            playerSmallAScore = smallAScore
            playerBigAScore = bigAScore
            score = min(smallAScore,bigAScore)
            playerSmallAScore = score
        } else if playerTotalScore + bigAScore == 21 {
            playerSmallAScore = smallAScore
            playerBigAScore = bigAScore
            score = max(smallAScore,bigAScore)
            playerBigAScore = score
        } else if playerTotalScore + bigAScore > 21 && playerTotalScore + smallAScore < 21 {
            playerSmallAScore = smallAScore
            playerBigAScore = bigAScore
            score = min(smallAScore,bigAScore)
            playerSmallAScore = score
        } else if playerTotalScore + playerSmallAScore > 21 {
            playerSmallAScore = smallAScore
            playerBigAScore = bigAScore
            score = min(smallAScore,bigAScore)
            playerSmallAScore = score
        } else if playerTotalScore + bigAScore < 21 {
            playerSmallAScore = smallAScore
            playerBigAScore = bigAScore
            playerScoreLabel.text = "\(playerTotalScore + smallAScore)/\(playerTotalScore + bigAScore)"
            playerScoreLabel.sizeToFit()
        }
        return (score, playerScoreLabel.text!)
    }
    //取得玩家A的score
    func getPlayerAScore() -> (score: Int, scoreLabel: String) {
        playerAScore = 0
        switch playerACount {
        case 1:
            let aScore = decidePlayerSmallOrBigA(smallAScore: 1, bigAScore: 11)
            if playerTotalScore + playerBigAScore < 21 {
                playerScoreLabel.text = aScore.scoreLabel
            } else {
                playerAScore = aScore.score
            }
        case 2:
            let aScore = decidePlayerSmallOrBigA(smallAScore: 2, bigAScore: 12)
            if playerTotalScore + playerBigAScore < 21 {
                playerScoreLabel.text = aScore.scoreLabel
            } else {
                playerAScore = aScore.score
            }
        case 3:
            let aScore = decidePlayerSmallOrBigA(smallAScore: 3, bigAScore: 13)
            if playerTotalScore + playerBigAScore < 21 {
                playerScoreLabel.text = aScore.scoreLabel
            } else {
                playerAScore = aScore.score
            }
        case 4:
            let aScore = decidePlayerSmallOrBigA(smallAScore: 4, bigAScore: 14)
            if playerTotalScore + playerBigAScore < 21 {
                playerScoreLabel.text = aScore.scoreLabel
            } else {
                playerAScore = aScore.score
            }
        case 5:
            let aScore = decidePlayerSmallOrBigA(smallAScore: 5, bigAScore: 15)
            if playerTotalScore + playerBigAScore < 21 {
                playerScoreLabel.text = aScore.scoreLabel
            } else {
                playerAScore = aScore.score
            }
        default:
            break
        }
        return (playerAScore, playerScoreLabel.text!)
    }
    
    //取得莊家A的score
    func getPcAScore() -> Int {
        pcAScore = 0
        switch pcACount {
        case 1:
            if pcTotalScore >= 11 {
                pcAScore = 1
            } else {
                pcAScore = 11
            }
        case 2:
            if pcTotalScore >= 10 {
                pcAScore = 2
            } else {
                pcAScore = 12
            }
        case 3:
            if pcTotalScore >= 9 {
                pcAScore = 3
            } else {
                pcAScore = 13
            }
        case 4:
            if pcTotalScore >= 8 {
                pcAScore = 4
            } else {
                pcAScore = 14
            }
        case 5:
            if pcTotalScore >= 7 {
                pcAScore = 5
            } else {
                pcAScore = 15
            }
        default:
            break
        }
        return pcAScore
    }
    
    func showResultLabel(view: UIView, label: UILabel, result: String, color: UIColor) {
        view.isHidden = false
        label.text = result
        label.textColor = color
        label.sizeToFit()
    }
    
    func showBlackjackScore(label: UILabel) {
        label.text = "21"
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(red: 202/255, green: 158/255, blue: 33/255, alpha: 1)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.shadowColor = UIColor(red: 255/255, green: 211/255, blue: 98/255, alpha: 1)
    }
    
    func restoreScoreColor() {
        playerScoreLabel.font = UIFont.systemFont(ofSize: 16)
        playerScoreLabel.textColor = UIColor.black
        playerScoreLabel.shadowOffset = CGSize(width: 0, height: 0)
        playerScoreLabel.shadowColor = UIColor.clear
        pcScoreLabel.font = UIFont.systemFont(ofSize: 16)
        pcScoreLabel.textColor = UIColor.black
        pcScoreLabel.shadowOffset = CGSize(width: 0, height: 0)
        pcScoreLabel.shadowColor = UIColor.clear
    }
    
    func openANewRound() {
        playerTotalScore = 0
        pcTotalScore = 0
        playerACount = 0
        pcACount = 0
        playerCardIndex = 2
        playerSmallAScore = 0
        playerBigAScore = 0
        pcAScore = 0
        
        playerCards.shuffle()
        pcCards.shuffle()
        betBtn.isEnabled = true
        nextRoundBtn.isEnabled = false
        chipView.isHidden = true
        betView.isHidden = true
        pcScoreView.isHidden = true
        playerScoreView.isHidden = true
        playerResultView.isHidden = true
        pcResultView.isHidden = true
        logoView.isHidden = false
        pcBlackjack = false
        
        communicateLabel.text = "請下注"
        restoreScoreColor()
        
        for i in 0...4 {
            playerCardImageViews[i].image = UIImage(named: "")
            pcCardImageViews[i].image = UIImage(named: "")
        }
    }
    
    func showBrokeAndPlayAgainAlert() {
        let controller = UIAlertController(title: "錢不夠啦！", message: "是否領錢重回江湖？", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "yes", style: .default) { [self]_ in
            self.totalBet = 12000
            self.totalBetLabel.text = "\(self.totalBet)"
            self.totalBetLabel.sizeToFit()
            openANewRound()
        }
        controller.addAction(yesAction)
        let noAction = UIAlertAction(title: "no", style: .cancel, handler: nil)
        controller.addAction(noAction)
        present(controller, animated: true, completion: nil)
    }
    
    func loseChips(bet: Int) {
        totalBet -= bet
        communicateLabel.text = "-\(bet)"
        totalBetLabel.text = "\(totalBet)"
        totalBetLabel.sizeToFit()
        chipView.isHidden = true
        if totalBet < 0 {
            showBrokeAndPlayAgainAlert()
        }
    }
    
    func winChips(bet: Int) {
        totalBet += bet
        communicateLabel.text = "+\(bet)"
        totalBetLabel.text = "\(totalBet)"
        totalBetLabel.sizeToFit()
        chipView.isHidden = true
    }
    
    func playerTotalScoreAddPlayerAScore() -> Int {
        var totalScore = 0
        if playerTotalScore + playerBigAScore < 21 {
            totalScore = playerTotalScore + playerBigAScore
        } else if playerTotalScore + playerSmallAScore == 21 || playerTotalScore + playerBigAScore == 21 || (playerTotalScore + playerBigAScore > 21 && playerTotalScore + playerSmallAScore < 21) || playerTotalScore + playerSmallAScore > 21 {
            playerAScore = getPlayerAScore().score
            totalScore = playerTotalScore + playerAScore
        }
        return totalScore
    }
    
    func pcTotalScoreAddPcAScore() -> Int {
        var totalScore = 0
        totalScore = pcTotalScore + pcAScore
        return totalScore
    }
    
    func getPcCards() {
        //若莊家score < 17且共5張卡以下，自動加牌
        var pcCardIndex = 2
        
        while pcTotalScore + pcAScore < 17 && pcCardIndex <= 4 {
            print("**判斷莊家total是否<17,pcAScore:\(pcAScore)")
            let pcCard = pcCards[pcCardIndex]
            pcCardImageViews[pcCardIndex].image = UIImage(named: "\(pcCard.suit)\(pcCard.rank)")
            pcCardIndex += 1
            //沒有加到pc前兩張非A的score
            //計算score
            if pcCard.rank == "a" {
                pcACount += 1
            }
            //有出現過A
            if pcACount != 0 {
                //非A的score
                let pcCardScore = getRankScore(rank: pcCard.rank)
                pcTotalScore += pcCardScore
                
                //A的score
                pcAScore = getPcAScore()
                pcScoreLabel.text = "\(pcTotalScore + pcAScore)"
                pcScoreLabel.sizeToFit()
            }//沒有A
            else {
                let pcCardScore = getRankScore(rank: pcCard.rank)
                pcTotalScore += pcCardScore
                pcScoreLabel.text = "\(pcTotalScore)"
                pcScoreLabel.sizeToFit()
            }
        }
    }
    
    func winOrLose() {
        nextRoundBtn.isEnabled = true
        hitBtn.isEnabled = false
        standBtn.isEnabled = false
        betBtn.isEnabled = false
        chipView.isHidden = true
        playerScoreLabel.text = "\(playerTotalScore)"
        pcScoreLabel.text = "\(pcTotalScore)"
        if playerTotalScore == pcTotalScore {
            showResultLabel(view: playerResultView, label: playerResultLabel, result: "平手", color: UIColor.black)
            showResultLabel(view: pcResultView, label: pcResultLabel, result: "平手", color: UIColor.black)
            totalBet += bet
            totalBetLabel.text = "\(totalBet)"
            totalBetLabel.sizeToFit()
        } else if playerTotalScore > 21 && pcTotalScore > 21 {
            showResultLabel(view: playerResultView, label: playerResultLabel, result: "爆", color: UIColor.black)
            showResultLabel(view: pcResultView, label: pcResultLabel, result: "爆", color: UIColor.black)
            totalBet += bet
            totalBetLabel.text = "\(totalBet)"
            totalBetLabel.sizeToFit()
        } else if playerTotalScore > pcTotalScore && playerTotalScore <= 21 {
            showResultLabel(view: playerResultView, label: playerResultLabel, result: "贏", color: UIColor(red: 0/255, green: 146/255, blue: 72/255, alpha: 1))
            showResultLabel(view: pcResultView, label: pcResultLabel, result: "輸", color: UIColor.red)
            winChips(bet: bet*2)
        } else if pcTotalScore > 21 {
            showResultLabel(view: playerResultView, label: playerResultLabel, result: "贏", color: UIColor(red: 0/255, green: 146/255, blue: 72/255, alpha: 1))
            showResultLabel(view: pcResultView, label: pcResultLabel, result: "爆", color: UIColor.red)
            winChips(bet: bet*2)
        } else if pcTotalScore > playerTotalScore && pcTotalScore <= 21 {
            showResultLabel(view: playerResultView, label: playerResultLabel, result: "輸", color: UIColor.red)
            showResultLabel(view: pcResultView, label: pcResultLabel, result: "贏", color: UIColor(red: 0/255, green: 146/255, blue: 72/255, alpha: 1))
            loseChips(bet: bet)
        } else if playerTotalScore > 21 {
            showResultLabel(view: playerResultView, label: playerResultLabel, result: "爆", color: UIColor.red)
            showResultLabel(view: pcResultView, label: pcResultLabel, result: "贏", color: UIColor(red: 0/255, green: 146/255, blue: 72/255, alpha: 1))
        } else if pcBlackjack == true {
            showResultLabel(view: playerResultView, label: playerResultLabel, result: "輸", color: UIColor.red)
            showResultLabel(view: pcResultView, label: pcResultLabel, result: "贏", color: UIColor(red: 0/255, green: 146/255, blue: 72/255, alpha: 1))
            loseChips(bet: bet)
        }
        if totalBet <= 0 {
            showBrokeAndPlayAgainAlert()
        }
    }
    
    @IBAction func showBetBtn(_ sender: UIButton) {
        betView.isHidden = false
    }
    
    @IBAction func placeABet(_ sender: UIButton) {
        logoView.isHidden = true
        hitBtn.isEnabled = true
        standBtn.isEnabled = true
        betBtn.isEnabled = false
        //下注
        switch sender.tag {
        case 0:
            bet = 1000
            if totalBet >= 1000 {
                showBetLabel()
            } else {
                showBrokeAndPlayAgainAlert()
            }
        case 1:
            bet = 1500
            if totalBet >= 1500 {
                showBetLabel()
            } else {
                showBrokeAndPlayAgainAlert()
            }
        case 2:
            bet = 2000
            if totalBet >= 2000 {
                showBetLabel()
            } else {
                showBrokeAndPlayAgainAlert()
            }
        case 3:
            bet = 2500
            if totalBet >= 2500 {
                showBetLabel()
            } else {
                showBrokeAndPlayAgainAlert()
            }
        case 4:
            bet = 3000
            if totalBet >= 3000 {
                showBetLabel()
            } else {
                showBrokeAndPlayAgainAlert()
            }
        default:
            break
        }
        betView.isHidden = true
        
        //發牌各2張
        let playerCard1 = playerCards[0]
        let playerCard2 = playerCards[1]
        let pcCard1 = pcCards[0]
        let pcCard2 = pcCards[1]
        playerCardImageViews[0].image = UIImage(named: "\(playerCard1.suit)\(playerCard1.rank)")
        playerCardImageViews[1].image = UIImage(named: "\(playerCard2.suit)\(playerCard2.rank)")
        pcCardImageViews[0].image = UIImage(named: "背面")
        pcCardImageViews[1].image = UIImage(named: "\(pcCard2.suit)\(pcCard2.rank)")
        playerScoreView.isHidden = false
        pcScoreView.isHidden = false
        
        //計算score
        //計算玩家score
        if playerCard1.rank == "a" {
            playerACount += 1
        } else if playerCard2.rank == "a" {
            playerACount += 1
        }
        
        if playerACount != 0 {
            //非A的score
            let playerCard1Score = getRankScore(rank: playerCard1.rank)
            let playerCard2Score = getRankScore(rank: playerCard2.rank)
            playerTotalScore += playerCard1Score
            playerTotalScore += playerCard2Score
            //A的score
            if playerTotalScore + playerBigAScore < 21 {
                let score = getPlayerAScore().scoreLabel
                playerScoreLabel.text = score
            } else {
                let aScore = getPlayerAScore().score
                playerScoreLabel.text = "\(playerTotalScore + aScore)"
                playerScoreLabel.sizeToFit()
            }
        } else {
            //非A的score
            let playerCard1Score = getRankScore(rank: playerCard1.rank)
            let playerCard2Score = getRankScore(rank: playerCard2.rank)
            playerTotalScore += playerCard1Score
            playerTotalScore += playerCard2Score
            playerScoreLabel.text = "\(playerTotalScore)"
            playerScoreLabel.sizeToFit()
        }
        
        //計算莊家score
        if pcCard2.rank == "a" {
            pcACount += 1
        } else if pcCard1.rank == "a" {
            pcACount += 1
        }
        
        if pcACount != 0 {
            if pcCard1.rank == "a" && pcACount == 1 {
                let pcCard2Score = getRankScore(rank: pcCard2.rank)
                pcTotalScore += pcCard2Score
                pcAScore = getPcAScore()
                pcScoreLabel.text = "\(pcCard2Score)"
                pcScoreLabel.sizeToFit()
            } else if pcCard2.rank == "a" && pcACount == 1 {
                if pcACount == 1 {
                    let pcCard1Score = getRankScore(rank: pcCard1.rank)
                    pcTotalScore += pcCard1Score
                    let pcCard2Score = getPcAScore()
                    pcScoreLabel.text = "\(pcCard2Score)"
                    pcScoreLabel.sizeToFit()
                } else { //2張A,只顯示第二張11點
                    let pc2CardScore = getPcAScore()
                    pcScoreLabel.text = "\(pc2CardScore - 1)"
                    pcScoreLabel.sizeToFit()
                }
            }
        } else {
            let pcCard1Score = getRankScore(rank: pcCard1.rank)
            let pcCard2Score = getRankScore(rank: pcCard2.rank)
            pcTotalScore += pcCard1Score
            pcTotalScore += pcCard2Score
            pcScoreLabel.text = "\(pcCard2Score)"
            pcScoreLabel.sizeToFit()
        }
        
        //若出現blackjack則判斷輸贏
        //兩方都blackjack
        if (playerTotalScore + playerSmallAScore == 21 || playerTotalScore + playerBigAScore == 21) && pcTotalScore + pcAScore == 21 {
            nextRoundBtn.isEnabled = true
            //pc第一張翻牌
            pcCardImageViews[0].image = UIImage(named: "\(pcCard1.suit)\(pcCard1.rank)")
            showBlackjackScore(label: pcScoreLabel)
            showBlackjackScore(label: playerScoreLabel)
            showResultLabel(view: playerResultView, label: playerResultLabel, result: "平手", color: UIColor.black)
            showResultLabel(view: pcResultView, label: pcResultLabel, result: "平手", color: UIColor.black)
            winChips(bet: bet)
        } //玩家blackjack
        else if (playerTotalScore + playerSmallAScore == 21 || playerTotalScore + playerBigAScore == 21) {
            nextRoundBtn.isEnabled = true
            pcCardImageViews[0].image = UIImage(named: "\(pcCard1.suit)\(pcCard1.rank)")
            showBlackjackScore(label: playerScoreLabel)
            
            //如果莊家前2張牌已經>=17，顯示pcTotalScore
            if (pcACount != 0 && pcTotalScore + pcAScore >= 17) || pcACount == 0 && pcTotalScore >= 17 {
                if pcACount != 0 {
                    pcTotalScore += pcAScore
                    pcScoreLabel.text = "\(pcTotalScore)"
                    pcScoreLabel.sizeToFit()
                } else {
                    pcScoreLabel.text = "\(pcTotalScore)"
                    pcScoreLabel.sizeToFit()
                }
            }
            
            //如果莊家未達17，開牌直到 score >= 17
            var pcCardIndex = 2
            var pcAScorePlayerBJ = 0
            while pcTotalScore < 17 && pcCardIndex <= 4 {
                let pcCard = pcCards[pcCardIndex]
                pcCardImageViews[pcCardIndex].image = UIImage(named: "\(pcCard.suit)\(pcCard.rank)")
                pcCardIndex += 1
                
                if pcCard.rank == "a" {
                    pcACount += 1
                }
                
                //計算score
                //有出現過A
                if pcACount != 0 {
                    //非A的score
                    let pcCardScore = getRankScore(rank: pcCard.rank)
                    pcTotalScore += pcCardScore
                    
                    //A的score
                    pcAScorePlayerBJ = getPcAScore()
                    pcScoreLabel.text = "\(pcTotalScore + pcAScorePlayerBJ)"
                    pcScoreLabel.sizeToFit()
                }//沒有A
                else {
                    let pcCardScore = getRankScore(rank: pcCard.rank)
                    pcTotalScore += pcCardScore
                    pcScoreLabel.text = "\(pcTotalScore)"
                    pcScoreLabel.sizeToFit()
                }
            }
            
            //判斷輸贏
            if pcTotalScore + pcAScorePlayerBJ > 21 {
                showResultLabel(view: playerResultView, label: playerResultLabel, result: "贏", color: UIColor(red: 0/255, green: 146/255, blue: 72/255, alpha: 1))
                showResultLabel(view: pcResultView, label: pcResultLabel, result: "爆", color: UIColor.red)
                winChips(bet: bet*3)
            } else if pcTotalScore + pcAScorePlayerBJ <= 21 {
                showResultLabel(view: playerResultView, label: playerResultLabel, result: "贏", color: UIColor(red: 0/255, green: 146/255, blue: 72/255, alpha: 1))
                showResultLabel(view: pcResultView, label: pcResultLabel, result: "輸", color: UIColor.red)
                winChips(bet: bet*3)
            }
        } //只有莊家blackjack的話，stand後才會判斷輸贏
        else if pcTotalScore + pcAScore == 21 {
            pcBlackjack = true
        }
    }
    
    @IBAction func hit(_ sender: UIButton) {
        betBtn.isEnabled = false
        
        //如果playerTotalScore<21可以加牌
        var playerTotalAddPlayerAScore = playerTotalScoreAddPlayerAScore()
        if playerACount != 0 && playerTotalAddPlayerAScore < 21 || playerACount == 0 && playerTotalScore < 21 {
            let playerCard = playerCards[playerCardIndex]
                        playerCardImageViews[playerCardIndex].image = UIImage(named: "\(playerCard.suit)\(playerCard.rank)")
                        playerCardIndex += 1
            
            //計算score
            if playerCard.rank == "a" {
                playerACount += 1
            }
            if playerACount != 0 { //有A
                //非A的score
                let playerCardScore = getRankScore(rank: playerCard.rank)
                playerTotalScore += playerCardScore
                
                //A的score
                _ = getPlayerAScore().score //如果是第三張之後才出現A，要取得playerBigAScore和playerSmallAScore才能正確判斷
                if playerTotalScore + playerBigAScore < 21 { //bigA = 0 所以沒有正確判斷
                    let aScore = getPlayerAScore().scoreLabel
                    playerScoreLabel.text = aScore
                    playerScoreLabel.sizeToFit()
                } else if playerTotalScore + playerSmallAScore == 21 || playerTotalScore + playerBigAScore == 21 || (playerTotalScore + playerBigAScore > 21 && playerTotalScore + playerSmallAScore < 21) || playerTotalScore + playerSmallAScore > 21 {
                    let aScore = getPlayerAScore().score
                    playerScoreLabel.text = "\(playerTotalScore + aScore)"
                    playerScoreLabel.sizeToFit()
                }
            } else { //沒A
                let playerCardScore = getRankScore(rank: playerCard.rank)
                playerTotalScore += playerCardScore
                playerScoreLabel.text = "\(playerTotalScore)"
                playerScoreLabel.sizeToFit()
            }
        }
        
        //如果玩家>=21，或是已拿5張牌，莊家第一張翻牌，若莊家<17自動加牌，並判斷輸贏
        playerTotalAddPlayerAScore = playerTotalScoreAddPlayerAScore() //如果有出現A，total+AScore要重新計算
        if playerACount != 0 && playerTotalAddPlayerAScore >= 21 || playerACount == 0 && playerTotalScore >= 21 || playerCardIndex == 5 {
            
            //莊家第一張翻牌，並顯示pcTotalScore
            let pcCard1 = pcCards[0]
            pcCardImageViews[0].image = UIImage(named: "\(pcCard1.suit)\(pcCard1.rank)")
            
            //若pc有出現新的A，total+AScore要重新計算
            let pcTotalAddPcAScore = pcTotalScoreAddPcAScore()
            //如果pcBlackjack
            if pcBlackjack == true {
                showBlackjackScore(label: pcScoreLabel)
                //若玩家在有大小兩種score時判斷輸贏，顯示大的score
                if playerACount != 0 && playerTotalScore + playerBigAScore < 21 {
                    playerTotalScore += playerBigAScore
                    playerScoreLabel.text = "\(playerTotalScore)"
                    playerScoreLabel.sizeToFit()
                }
                winOrLose()
            } //若莊家score < 17且共5張卡以下，自動加牌
            else if pcTotalAddPcAScore < 17 {
                getPcCards()
            }
            
            //若有A，total要加回A的score，以判斷輸贏
            if pcACount != 0 {
                pcTotalScore += pcAScore
                pcScoreLabel.text = "\(pcTotalScore)"
                pcScoreLabel.sizeToFit()
            } else {
                pcScoreLabel.text = "\(pcTotalScore)"
                pcScoreLabel.sizeToFit()
            }
           
            if playerACount != 0 {
                let total = playerTotalAddPlayerAScore
                playerTotalScore = total
            }

            //判斷輸贏
            winOrLose()
        }
    }
    
    @IBAction func stand(_ sender: UIButton) {
        //若玩家在有大小兩種score時按stand，顯示大的score
        if playerACount != 0 && playerTotalScore + playerBigAScore < 21 {
            playerScoreLabel.text = "\(playerTotalScore + playerBigAScore)"
        }
        
        //莊家第一張翻牌
        let pcCard1 = pcCards[0]
        pcCardImageViews[0].image = UIImage(named: "\(pcCard1.suit)\(pcCard1.rank)")
        
        //若莊家2張牌就 >=17，則判斷輸贏，並顯示包含第一張的score
        if pcACount != 0 { //如果有A
            if pcBlackjack == true { //如果pcBlackjack
                pcCardImageViews[0].image = UIImage(named: "\(pcCard1.suit)\(pcCard1.rank)")
                showBlackjackScore(label: pcScoreLabel)
                //若玩家在有大小兩種score時判斷輸贏，顯示大的score
                if playerACount != 0 && playerTotalScore + playerBigAScore < 21 {
                    playerTotalScore += playerBigAScore
                    playerScoreLabel.text = "\(playerTotalScore)"
                    playerScoreLabel.sizeToFit()
                }
                winOrLose()
            } else { //如果有A，要加回A的score再判斷total是否 >=17
                let aScore = getPcAScore()
                  if pcTotalScore + aScore >= 17 {
                    pcScoreLabel.text = "\(pcTotalScore + aScore)"
                    pcScoreLabel.sizeToFit()
                    //判斷輸贏
                    winOrLose()
                }
            }
        } else { //沒有A
            if pcTotalScore >= 17 {
                pcScoreLabel.text = "\(pcTotalScore)"
                pcScoreLabel.sizeToFit()
                //判斷輸贏
                winOrLose()
            }
        }
        
        //若莊家score < 17且共5張卡以下，自動加牌
        getPcCards()
        
        //判斷輸贏
        //若有A，total要加回A的score
        if playerACount != 0 {
            let total = playerTotalScoreAddPlayerAScore()
            playerTotalScore = total
        }
        if pcACount != 0 {
            pcTotalScore += pcAScore
        }
        winOrLose()
    }
    
    @IBAction func nextRound(_ sender: UIButton) {
        openANewRound()
    }
}

