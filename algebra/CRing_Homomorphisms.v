(* CRing_Homomorphisms.v, v1.0, 28april2004, Bart Kirkels *)

(** printing [+] %\ensuremath+% #+# *)
(** printing [*] %\ensuremath\times% #&times;# *)
(** printing ['] %\ensuremath.% #.# *)
(** printing [-] %\ensuremath{-}% #&minus;# *)
(** printing [--] %\ensuremath-% #&minus;# *)
(** printing [=] %\ensuremath=% #&equiv;# *)
(** printing [#] %\ensuremath\#% *)
(** printing Zero %\ensuremath{\mathbf0}% #0# *)
(** printing One %\ensuremath{\mathbf1}% #1# *)
(** printing phi %\ensuremath{\phi}%  *)

Require Export CRings.

(**
* Ring Homomorphisms
** Definition of Ring Homomorphisms
Let [R] and [S] be rings, and [phi : R -> S].
*)

Section RingHom_Definition.

Variables R S : CRing.

Section RingHom_Preliminary.

Variable phi : CSetoid_fun R S.

Definition fun_pres_plus := forall x y:R, phi (x[+]y) [=] (phi x) [+] (phi y).
Definition fun_pres_mult := forall x y:R, phi (x[*]y) [=] (phi x) [*] (phi y).
Definition fun_pres_unit := (phi (One:R)) [=] (One:S).

End RingHom_Preliminary.


Record RingHom : Type :=
  {rhmap :> CSetoid_fun R S;
   rh1 : fun_pres_plus rhmap;
   rh2 : fun_pres_mult rhmap;
   rh3 : fun_pres_unit rhmap}.
   
End RingHom_Definition.

(**
** Lemmas on Ring Homomorphisms
Let [R] and [S] be rings and [f] a ring homomorphism from [R] to [S].
*** Axioms on Ring Homomorphisms
*)

Section RingHom_Lemmas.

Variables R S : CRing.

Section RingHom_Axioms.

Variable f : RingHom R S.

Lemma rh_strext : forall x y:R, (f x) [#] (f y) -> x [#] y.
elim f; intuition.
assert (fun_strext rhmap0); elim rhmap0; intuition.
Qed.

Lemma rh_pres_plus : forall x y:R, f (x[+]y) [=] (f x) [+] (f y).
elim f; auto.
Qed.

Lemma rh_pres_mult : forall x y:R, f (x[*]y) [=] (f x) [*] (f y).
elim f; auto.
Qed.

Lemma rh_pres_unit : (f (One:R)) [=] (One:S).
elim f; auto.
Qed.

End RingHom_Axioms.


Hint Resolve rh_strext rh_pres_plus rh_pres_mult rh_pres_unit : algebra.

(**
*** Facts on Ring Homomorphisms
*)

Section RingHom_Basics.

Variable f : RingHom R S.

Lemma rh_pres_zero : (f (Zero:R)) [=] (Zero:S).
astepr ((f Zero)[-](f Zero)).
astepr ((f (Zero[+]Zero))[-](f Zero)).
Step_final ((f Zero[+]f Zero)[-]f Zero).
Qed.

Lemma rh_pres_minus : forall x:R, (f [--]x) [=] [--] (f x).
intro x; apply (cg_cancel_lft S (f x)).
astepr (Zero:S).
astepl (f (x[+][--]x)).
Step_final (f (Zero:R)); try apply rh_pres_zero.
Qed.

Lemma rh_apzero : forall x:R, (f x) [#] Zero -> x [#] Zero.
intros x X; apply (cg_ap_cancel_rht R x (Zero:R) x).
astepr x.
apply (rh_strext f (x[+]x) x).
astepl ((f x)[+](f x)).
astepr ((Zero:S) [+] (f x)).
apply (op_rht_resp_ap S (f x) (Zero:S) (f x)).
assumption.
Qed.

End RingHom_Basics.

End RingHom_Lemmas.


Hint Resolve rh_strext rh_pres_plus rh_pres_mult rh_pres_unit : algebra.
Hint Resolve rh_pres_zero rh_pres_minus rh_apzero : algebra.