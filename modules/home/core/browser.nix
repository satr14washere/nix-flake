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
      
      "ocabkmapohekeifbkoelpmppmfbcibna" # xoom redirector
      "fkagelmloambgokoeokbpihmgpkbgbfm" # indie wiki buddy
      "bggfcpfjbdkhfhfmkjpbhnkhnpjjeomc" # github material icons
      "hfckonpdalooejghjpbpimhcgighijck" # chess move confirm
      "babnnfmbjokkeieobamoifmeapbbfhje" # medium unlock
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsor block
      "ekcgkejcjdcmonfpmnljobemcbpnkamh" # whatsapp web plus
    ];
  };
}