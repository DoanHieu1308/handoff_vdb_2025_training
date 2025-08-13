/// =================== Base Enum ===================//

enum TypeOfDevice { bigDevice, smallDevice, normalDevice, mediumSmallDevice }

enum IZIButtonType { DEFAULT, OUTLINE }

/// [AssetImageType] is type of Image.
/// [SVG], [IMAGE].
enum AssetImageType { SVG, IMAGE }

/// [ImageUrlType] is type of Image url.
/// [NETWORK], [ASSET], [FILE]
enum ImageUrlType { NETWORK, ASSET, FILE, UNKNOWN }

enum InputType {
  TEXT,
  PASSWORD,
  NUMBER,
  DOUBLE,
  PRICE,
  EMAIL,
  PHONE,
  INCREMENT,
  MULTILINE,
  DATE,
}

enum PostOptionType { onlyMe, album, instagram, threads, label }

enum MatchType { hashtag, link }