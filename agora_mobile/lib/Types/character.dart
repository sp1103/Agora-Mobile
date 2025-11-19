class Character {
  final String id;
  final String name;
  final String era;
  final String photoUrl;
  final String systemPrompt;

  const Character({
    required this.id,
    required this.name,
    required this.era,
    required this.photoUrl,
    required this.systemPrompt,
  });

  static final List<Character> allCharacters = [
    Character(
        id: 'AL',
        name: "Abraham Lincoln",
        era: "1809-1865",
        photoUrl: "assets/characters/AL.jpg",
        systemPrompt: "systemPrompt"),
    Character(
        id: "GW",
        name: "George Washington",
        era: "1789-1797",
        photoUrl: "assets/characters/GW.jpg",
        systemPrompt: ""),
    Character(
        id: "TR",
        name: "Theodore Roosevelt",
        era: "1901-1909",
        photoUrl: "assets/characters/TR.jpg",
        systemPrompt: ""),
    Character(
      id: "FD",
      name: "Frederick Douglass",
      era: "1818-1895",
      photoUrl: "assets/characters/FD.jpg",
      systemPrompt: "",
    ),
    Character(
      id: "ER",
      name: "Eleanor Roosevelt",
      era: "1933-1945",
      photoUrl: "assets/characters/ER.jpg",
      systemPrompt: "",
    )
  ];

  static String createMessage(character, legislationMessage) {
    String basePrompt =
        """[System note: You are roleplaying as ${character.name}, speaking in their authentic voice and manner. Address the user warmly as befitting your character. 
            Current context: The user is discussing the following legislation:
            $legislationMessage

            When responding:
            - Draw parallels to bills you signed, vetoed, or legislation from your era that relates to this topic
            - Speak in 2-4 sentences, as if in thoughtful conversation
            - Use language and references authentic to your time period (${character.era})
            - Share your perspective on how this legislation aligns with or differs from the principles you championed]""";

    switch (character.name) {
      case "Abraham Lincoln":
        return "$basePrompt\n- Reference the Civil War context and preservation of the Union";

      case "Frederick Douglass":
        return "$basePrompt\n- Emphasize civil rights, abolition, and human dignity";
      default:
        return basePrompt;
    }
  }
}
