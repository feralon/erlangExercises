-module(exercises).
-export([reverseBin/1,reverseBits/1,decToBin/1,term_to_packet/1,
    packet_to_term/1,test_packets/0]).

%reverse bytes
reverseBin(<<A,B/binary>>)-> <<(reverseBin(B))/binary,A>>;
reverseBin(A)-> A.

%Reverse Bits
reverseBits(<<A:1,B/bitstring>>)-> <<(reverseBits(B))/bitstring,A:1>>;
reverseBits(A)->A.


aproxB2(Num,B)->Tm = math:pow(2,B),
if
    Tm =< Num -> aproxB2(Num,B+1);
    true ->B
end.

remZ(Bit = <<_:1>>)->Bit;
remZ(<<0:1,Bitstr/bitstring>>)->remZ(Bitstr);
remZ(All = <<1:1,_/bitstring>>)->All.


decToBin(Dec)-> Digit = aproxB2(Dec,0),
                New = remZ(<<Dec:Digit>>),
                [X||<<X:1>> <= New].

term_to_packet(Term) -> Bin = term_to_binary(Term),
                        <<A,_/binary>> = Bin,
                        Header = <<A,2#1101,0,1>>,
                        <<Header/binary,Bin/binary>>.

packet_to_term(<<H:4/unit:8,X/binary>>)->%io:format("The header is ~w~n",[<<H:32>>]),
          binary_to_term(X).

test_packets() -> for(0,9999,fun test_packets2/1),"Fin".

for(X,X,_)->ok;
for(X,Fin,Fun)->
  try Fun(X)
    catch _:_ -> io:format("Fallo en la prueba numero ~w~n", [X])
    end,
for(X + 1,Fin,Fun).


test_packets2(N)-> N = packet_to_term(term_to_packet(N)),
  if
    N =< 20 -> error("Error");
    true -> ok
  end.
