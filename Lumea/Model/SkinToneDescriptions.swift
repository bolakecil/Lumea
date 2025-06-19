import Foundation

class SkinToneDescriptions {
    static func getDescription(for skintoneGroup: String, undertone: String) -> String {
        let combination = "\(skintoneGroup) \(undertone.capitalized)"
        
        switch combination {
        case "Fair Cool":
            return """
            Your facial scan reveals a fair cool skin, which pairs beautifully with **silver jewelry** and **rosy hues**.  
            **Avoid** **gold tones**—they might clash with your natural undertone.
            """
        case "Fair Neutral":
            return """
            Your facial scan reveals a fair neutral skin, which works well with both **silver and gold jewelry**.  
            **Avoid** foundation that's too **yellow** or **pink**, it might not blend naturally.
            """
        case "Fair Warm":
            return """
            Your facial scan reveals a fair warm skin, which suits **peach tones**, **gold jewelry**, and **coral makeup**.  
            **Avoid** **cool pink shades**—they can look off on your complexion.
            """
        case "Light Cool":
            return """
            Your facial scan reveals a light cool skin, which looks great with **silver jewelry** and **pink makeup**.  
            **Avoid** **golden** or **orange tones**, they can make your skin look dull.
            """
        case "Light Neutral":
            return """
            Your facial scan reveals a light neutral skin, which is flexible and matches many shades.  
            **Watch out** for colors that are too **warm** or **cool**, they can look off.
            """
        case "Light Warm":
            return """
            Your facial scan reveals a light warm skintone suits **earthy tones**, **gold jewelry**, and **peachy makeup**.  
            **Avoid** **cool tones** and **pink-based foundations**, they can wash you out!
            """
        case "Medium Cool":
            return """
            Your facial scan reveals a medium cool skintone, which fits well with **silver jewelry** and **berry makeup**.  
            **Avoid** **yellow** or **orange shades**—they may not match your tone.
            """
        case "Medium Neutral":
            return """
            Your facial scan reveals a medium neutral, which suits most colors easily.  
            **Avoid** very **warm** or very **cool tones** that might feel too strong.
            """
        case "Medium Warm":
            return """
            Your facial scan reveals a medium warm, which glows with **gold jewelry** and **peachy tones**.  
            **Stay away** from **cool** or **ashy shades**—they can make you look pale.
            """
        case "Tan Cool":
            return """
            Your facial scan reveals a tan cool skin, which stands out with **rich jewel tones** and **cool-based makeup**.  
            **Avoid** **golden hues**—they can overpower your undertone.
            """
        case "Tan Neutral":
            return """
            Your facial scan revals a tan neutral skin, which balances **warm** and **cool colors** effortlessly.  
            **Avoid** foundations with strong **yellow** or **red base**—they may look uneven.
            """
        case "Tan Warm":
            return """
            Your facial scan reveals a tan warm skin, which pairs well with **terracotta**, **gold accents**, and **bronzy looks**.  
            **Steer clear** of **bluish** or **cool-pink tones**—they can dull your glow.
            """
        case "Deep Cool":
            return """
            Your facial scan reveals a deep cool skin, which shines with **cool colors** like **plum** and **navy**.  
            **Avoid** **warm tones**—they can look too orange on your skin.
            """
        case "Deep Neutral":
            return """
            Your facial scan reveals a deep neutral skintone can handle both **warm** and **cool makeup shades**.  
            **Be careful** with **orange** or **gray foundations**—they can look unnatural.
            """
        case "Deep Warm":
            return """
            Your facial scan reveals a deep warm skin, which radiates with **copper**, **gold**, and **warm browns**.  
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
