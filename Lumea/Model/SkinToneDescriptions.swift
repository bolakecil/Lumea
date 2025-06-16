import Foundation

class SkinToneDescriptions {
    static func getDescription(for skintoneGroup: String, undertone: String) -> String {
        let combination = "\(skintoneGroup) \(undertone.capitalized)"
        
        switch combination {
        case "Fair Cool":
            return """
            Fair Cool skintone pairs beautifully with **silver jewelry** and **rosy hues**.  
            **Avoid** **gold tones**—they might clash with your natural undertone.
            """
        case "Fair Neutral":
            return """
            Fair Neutral skintone works well with both **silver and gold jewelry**.  
            **Avoid** foundation that's too **yellow** or **pink**, it might not blend naturally.
            """
        case "Fair Warm":
            return """
            Fair Warm skintone suits **peach tones**, **gold jewelry**, and **coral makeup**.  
            **Avoid** **cool pink shades**—they can look off on your complexion.
            """
        case "Light Cool":
            return """
            Light Cool skintone looks great with **silver jewelry** and **pink makeup**.  
            **Avoid** **golden** or **orange tones**, they can make your skin look dull.
            """
        case "Light Neutral":
            return """
            Light Neutral skintone is flexible and matches many shades.  
            **Watch out** for colors that are too **warm** or **cool**, they can look off.
            """
        case "Light Warm":
            return """
            Light Warm skintone suits **earthy tones**, **gold jewelry**, and **peachy makeup**.  
            **Avoid** **cool tones** and **pink-based foundations**, they can wash you out!
            """
        case "Medium Cool":
            return """
            Medium Cool skintone fits well with **silver jewelry** and **berry makeup**.  
            **Avoid** **yellow** or **orange shades**—they may not match your tone.
            """
        case "Medium Neutral":
            return """
            Medium Neutral skintone suits most colors easily.  
            **Avoid** very **warm** or very **cool tones** that might feel too strong.
            """
        case "Medium Warm":
            return """
            Medium Warm skintone glows with **gold jewelry** and **peachy tones**.  
            **Stay away** from **cool** or **ashy shades**—they can make you look pale.
            """
        case "Tan Cool":
            return """
            Tan Cool skintone stands out with **rich jewel tones** and **cool-based makeup**.  
            **Avoid** **golden hues**—they can overpower your undertone.
            """
        case "Tan Neutral":
            return """
            Tan Neutral skintone balances **warm** and **cool colors** effortlessly.  
            **Avoid** foundations with strong **yellow** or **red base**—they may look uneven.
            """
        case "Tan Warm":
            return """
            Tan Warm skintone pairs well with **terracotta**, **gold accents**, and **bronzy looks**.  
            **Steer clear** of **bluish** or **cool-pink tones**—they can dull your glow.
            """
        case "Deep Cool":
            return """
            Deep Cool skintone shines with **cool colors** like **plum** and **navy**.  
            **Avoid** **warm tones**—they can look too orange on your skin.
            """
        case "Deep Neutral":
            return """
            Deep Neutral skintone can handle both **warm** and **cool makeup shades**.  
            **Be careful** with **orange** or **gray foundations**—they can look unnatural.
            """
        case "Deep Warm":
            return """
            Deep Warm skintone radiates with **copper**, **gold**, and **warm browns**.  
            **Avoid** **cool silvers** or **icy tones**—they can make your skin look ashy.
            """
        default:
            return """
            Your skintone has unique characteristics that make you special.  
            Experiment with different shades to find what works best for you!
            """
        }
    }
}
