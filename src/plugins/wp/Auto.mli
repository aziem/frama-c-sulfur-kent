(**************************************************************************)
(*                                                                        *)
(*  This file is part of WP plug-in of Frama-C.                           *)
(*                                                                        *)
(*  Copyright (C) 2007-2017                                               *)
(*    CEA (Commissariat a l'energie atomique et aux energies              *)
(*         alternatives)                                                  *)
(*                                                                        *)
(*  you can redistribute it and/or modify it under the terms of the GNU   *)
(*  Lesser General Public License as published by the Free Software       *)
(*  Foundation, version 2.1.                                              *)
(*                                                                        *)
(*  It is distributed in the hope that it will be useful,                 *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *)
(*  GNU Lesser General Public License for more details.                   *)
(*                                                                        *)
(*  See the GNU Lesser General Public License version 2.1                 *)
(*  for more details (enclosed in the file licenses/LGPLv2.1).            *)
(*                                                                        *)
(**************************************************************************)

open Tactical
open Strategy

(* -------------------------------------------------------------------------- *)
(** {2 Registered Strategies} 
    It is always safe to apply strategies to any goal. *)
(* -------------------------------------------------------------------------- *)

val array : ?priority:float -> selection -> strategy
val choice : ?priority:float -> selection -> strategy
val absurd : ?priority:float -> selection -> strategy
val contrapose : ?priority:float -> selection -> strategy
val compound : ?priority:float -> selection -> strategy
val cut : ?priority:float -> ?modus:bool -> selection -> strategy
val filter : ?priority:float -> ?anti:bool -> unit -> strategy
val havoc : ?priority:float -> havoc:selection -> addr:selection -> strategy
val separated : ?priority:float -> selection -> strategy
val instance : ?priority:float -> selection -> selection list -> strategy
val lemma : ?priority:float -> ?at:selection -> string -> selection list -> strategy
val intuition : ?priority:float -> selection -> strategy
val range : ?priority:float -> selection -> vmin:int -> vmax:int -> strategy
val split : ?priority:float -> selection -> strategy
val definition : ?priority:float -> selection -> strategy

(* -------------------------------------------------------------------------- *)
(** {2 Registered Heuristics} *)
(* -------------------------------------------------------------------------- *)

val auto_split : Strategy.heuristic
val auto_range : Strategy.heuristic

module Range :
sig
  type rg
  val compute : Conditions.sequence -> rg
  val ranges : rg -> (int * int) Lang.F.Tmap.t
  val bounds : rg -> (int option * int option) Lang.F.Tmap.t
end

(* -------------------------------------------------------------------------- *)
(** {2 Trusted Tactical Process} 
    Tacticals with hand-written process are not safe.
    However, the combinators below are guarantied to be sound. *)
(* -------------------------------------------------------------------------- *)

(** Find a contradiction. *)
val t_absurd : process

(** Keep goal unchanged. *)
val t_id : process

(** Apply a description to a leaf goal. Same as [t_descr "..." t_id]. *)
val t_finally : string -> process

(** Apply a description to each sub-goal *)
val t_descr : string -> process -> process

(** Split with [p] and [not p]. *)
val t_split : ?pos:string -> ?neg:string -> Lang.F.pred -> process

(** Prove condition [p] and use-it as a forward hypothesis. *)
val t_cut : ?by:string -> Lang.F.pred -> process -> process

(** Case analysis: [t_case p a b] applies process [a] under hypothesis [p] 
    and process [b] under hypothesis [not p]. *)
val t_case : Lang.F.pred -> process -> process -> process

(** Complete analysis: applies each process under its guard, and proves that
    all guards are complete. *)
val t_cases : ?complete:string -> (Lang.F.pred * process) list -> process

(** Apply second process to every goal generated by the first one. *)
val t_chain : process -> process -> process

(** @raise Invalid_argument when range is empty *)
val t_range : Lang.F.term -> int -> int ->
  upper:process -> lower:process -> range:process -> process

(** Prove [src=tgt] then replace [src] by [tgt]. *)
val t_replace :
  ?equal:string -> src:Lang.F.term -> tgt:Lang.F.term -> process -> process

(**************************************************************************)
