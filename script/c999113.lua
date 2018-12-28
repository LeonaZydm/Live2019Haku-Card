--Imperium Slate Warrior
function c999113.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c999113.ffilter,3,false)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999113.altcon)
	e0:SetOperation(c999113.altop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c999113.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c999113.spcon)
	e2:SetOperation(c999113.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999113,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,999113)
	e3:SetOperation(c999113.regop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(c999113.indcon)
	e4:SetTarget(c999113.indtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c999113.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999113.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999113.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end
function c999113.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c999113.spfilter(c,fc)
	return c999113.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c999113.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.CheckReleaseGroup(tp,c999113.spfilter,3,nil,c)
end
function c999113.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c999113.spfilter,3,3,nil,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c999113.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(999113,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(c999113.thtg)
	e1:SetOperation(c999113.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c999113.thfilter(c)
	return c:IsSetCard(0xabdf) and c:IsAbleToHand()
end
function c999113.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999113.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999113.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999113.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c999113.indfil(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c999113.indcon(e)
	return Duel.IsExistingMatchingCard(c999113.indfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,3,nil)
end
function c999113.indtg(e,c)
	return c==e:GetHandler() or c:IsType(TYPE_CONTINUOUS)
end
