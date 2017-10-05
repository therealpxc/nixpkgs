{
  asciidoctor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jnf9y8q5asfdzilp8vcqafrc2faj719df4yh1993mh6jd0iqdy4";
      type = "gem";
    };
    version = "1.5.6.1";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  charlock_holmes = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09dn56sx0kcw0k8ypiynhnhhiq7ff9m7b57l8wvnxj82wxsjb54y";
      type = "gem";
    };
    version = "0.7.5";
  };
  creole = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00rcscz16idp6dx0dk5yi5i0fz593i3r6anbn5bg2q07v3i025wm";
      type = "gem";
    };
    version = "0.5.0";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  expression_parser = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1938z3wmmdabqxlh5d5c56xfg1jc6z15p7zjyhvk7364zwydnmib";
      type = "gem";
    };
    version = "0.9.0";
  };
  gemojione = {
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ayk8r147k1s38nj18pwk76npx1p7jhi86silk800nj913pjvrhj";
      type = "gem";
    };
    version = "3.3.0";
  };
  github-markup = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nyb9ck2c9z5qi86n7r52w0m126qpnvc93yh35cn8bwsnkjqx0iq";
      type = "gem";
    };
    version = "1.6.1";
  };
  gitlab-grit = {
    dependencies = ["charlock_holmes" "diff-lcs" "mime-types" "posix-spawn"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xgs3l81ghlc5nm75n0pz7b2cj3hpscfq5iy27c483nnjn2v5mc4";
      type = "gem";
    };
    version = "2.8.2";
  };
  gollum = {
    dependencies = ["gemojione" "gollum-lib" "kramdown" "mustache" "sinatra" "useragent"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "051pm2f50daiqcqy87aq4809x4c95iwwml6ca4wgvvmj5zkk6k5a";
      type = "gem";
    };
    version = "4.1.2";
  };
  gollum-grit_adapter = {
    dependencies = ["gitlab-grit"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fcibm63v1afc0fj5rki0mm51m7nndil4cjcjjvkh3yigfn4nr4b";
      type = "gem";
    };
    version = "1.0.1";
  };
  gollum-lib = {
    dependencies = ["gemojione" "github-markup" "gollum-grit_adapter" "nokogiri" "rouge" "sanitize" "stringex"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1filwvjfj5q2m6w4q274ai36d6f0mrsv2l2khhk4bv1q6pqby2fq";
      type = "gem";
    };
    version = "4.2.7";
  };
  htmlentities = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  kramdown = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12sral2xli39mnr4b9m2sxdlgam4ni0a1mkxawc5311z107zj3p0";
      type = "gem";
    };
    version = "1.9.0";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  mustache = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g5hplm0k06vwxwqzwn1mq5bd02yp0h3rym4zwzw26aqi7drcsl2";
      type = "gem";
    };
    version = "0.99.8";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "105xh2zkr8nsyfaj2izaisarpnkrrl9000y3nyflg9cbzrfxv021";
      type = "gem";
    };
    version = "1.8.1";
  };
  org-ruby = {
    dependencies = ["rubypants"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x69s7aysfiwlcpd9hkvksfyld34d8kxr62adb59vjvh8hxfrjwk";
      type = "gem";
    };
    version = "0.9.12";
  };
  posix-spawn = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pmxmpins57qrbr31bs3bm7gidhaacmrp4md6i962gvpq4gyfcjw";
      type = "gem";
    };
    version = "0.3.13";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19m7aixb2ri7p1n0iqaqx8ldi97xdhvbxijbyrrcdcl6fv5prqza";
      type = "gem";
    };
    version = "1.6.8";
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
      type = "gem";
    };
    version = "1.5.3";
  };
  RedCloth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m9dv7ya9q93r8x1pg2gi15rxlbck8m178j1fz7r5v6wr1avrrqy";
      type = "gem";
    };
    version = "4.3.2";
  };
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02kpahk5nkc33yxnn75649kzxaz073wvazr2zyg491nndykgnvcs";
      type = "gem";
    };
    version = "2.2.1";
  };
  rubypants = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xpqkslan2wkyal2h9qhplkr5d4sdn7q6csigrhnljjpp8j4qfsh";
      type = "gem";
    };
    version = "0.6.0";
  };
  sanitize = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xsv6xqrlz91rd8wifjknadbl3z5h6qphmxy0hjb189qbdghggn3";
      type = "gem";
    };
    version = "2.1.0";
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byxzl7rx3ki0xd7aiv1x8mbah7hzd8f81l65nq8857kmgzj1jqq";
      type = "gem";
    };
    version = "1.4.8";
  };
  stringex = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zc93v00av643lc6njl09wwki7h5yqayhh1din8zqfylw814l1dv";
      type = "gem";
    };
    version = "2.7.1";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0020mrgdf11q23hm1ddd6fv691l51vi10af00f137ilcdb2ycfra";
      type = "gem";
    };
    version = "2.0.8";
  };
  twitter-text = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1732h7hy1k152w8wfvjsx7b79alk45i5imwd37ia4qcx8hfm3gvg";
      type = "gem";
    };
    version = "1.14.7";
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14hr2dzqh33kqc0xchs8l05pf3kjcayvad4z1ip5rdjxrkfk8glb";
      type = "gem";
    };
    version = "0.0.7.4";
  };
  useragent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1139cjqyv1hk1qcw89k81ajjkqyakqgbcyvmfrsmjqi8yn9kgqhq";
      type = "gem";
    };
    version = "0.16.8";
  };
  wikicloth = {
    dependencies = ["builder" "expression_parser" "htmlentities" "nokogiri" "twitter-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c78r1rg93mb5rcrfxl01b162ma9sh46dhjksc4c9dngg62nhbjh";
      type = "gem";
    };
    version = "0.8.3";
  };
}