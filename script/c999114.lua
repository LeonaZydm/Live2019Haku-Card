--Impervious Recovering Sword
function c999114.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c999114.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c999114.cost)
	e1:SetTarget(c999114.target)
	e1:SetOperation(c999114.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,6853254)
	e2:SetTarget(c999114.reptg)
	e2:SetValue(c999114.repval)
	e2:SetOperation(c999114.repop)
	c:RegisterEffect(e2)
end
function c999114.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c999114.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR) and not c:IsPublic()
end
function c999114.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999114.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c999114.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
	Duel.ShuffleHand(tp)
end
function c999114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c999114.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabelObject():GetAttack()
	Duel.Recover(tp,atk,REASON_EFFECT)
end
function c999114.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xaedf) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c999114.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c999114.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(999114,0))
end
function c999114.repval(e,c)
	return c999114.repfilter(c,e:GetHandlerPlayer())
end
function c999114.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
