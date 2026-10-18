{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = map (id: { inherit id; }) [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden 
      "kokhpbhfeokchmbimdlaldcmlinjpipm" # 2fauth
      "gppongmhjkpfnbhagpmjfkannfbllamg" # wappalyzer
      
      "cejckpjfigehbeecbbfhangbknpidcnh" # timezone changer 
      "dmghijelimhndkbmpgbldicpogfkceaj" # dark mode 
      "cebifddlogbjhoibpjobhlamopmlpckl" # disable page visibility
      "efknglbfhoddmmfabeihlemgekhhnabb" # json viewer
      "bhchdcejhohfmigjafbampogmaanbfkg" # user agent switcher
      "bbppejejjfancffmhncgkhjdaikdgagc" # undisposition
      "hnafhkjheookmokbkpnfpmemlppjdgoi" # allow right click
      "hipjlflbbjaojdoecdgbelgofbfckpai" # enable user select
      "hdpoplemgeaioijkmoebnnjcilfjnjdi" # live hosts
      
      "ocabkmapohekeifbkoelpmppmfbcibna" # xoom redirector
      "fkagelmloambgokoeokbpihmgpkbgbfm" # indie wiki buddy
      "bggfcpfjbdkhfhfmkjpbhnkhnpjjeomc" # github material icons
      "hfckonpdalooejghjpbpimhcgighijck" # chess move confirm
      "babnnfmbjokkeieobamoifmeapbbfhje" # medium unlock
      "fbmkmdnlhacefjljljlbhkodfmfkijdh" # metube downloader
      "ghbmnnjooekpmoecnnnilnnbdlolhkhi" # google docs offline
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsor block
      "ekcgkejcjdcmonfpmnljobemcbpnkamh" # whatsapp web plus
    ];
  };
}