import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie";
import Option "mo:base/Option";
import List "mo:base/List";
import Text "mo:base/Text";
import Result "mo:base/Result";

actor {
  public type SuperHeroId = Nat32;

  public type SuperHero = {
    name: Text;
    powers: List.List<Text>;
  };

  private stable var next : SuperHeroId = 0;
  private stable var superHeroes : Trie.Trie<SuperHeroId, SuperHero> = Trie.empty();

  private func key(x: SuperHeroId): Trie.Key<SuperHeroId> {
    { hash = x; key = x; }
  };

  public func create(newHero: SuperHero): async SuperHeroId {
    let superHeroId = next;
    next += 1;
    
    superHeroes := Trie.replace(
      superHeroes,
      key(superHeroId),
      Nat32.equal,
      ?newHero
    ).0;

    return superHeroId;
  };

  public func getHero(id: SuperHeroId) : async ?SuperHero {
    let result = Trie.find(
      superHeroes,
      key(id),
      Nat32.equal
    );

    return result;
  };

  public func update(id: SuperHeroId, updateValue: SuperHero) : async Bool{
    let result = Trie.find(
      superHeroes,
      key(id),
      Nat32.equal
    );

    let exists = Option.isSome(result);
    
    if(exists) {
      superHeroes := Trie.replace(
        superHeroes,
        key(id),
        Nat32.equal,
        ?updateValue
      ).0;
    };

    return exists;
  };

};
