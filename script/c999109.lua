--Swift Slate Warrior
function c999109.initial_effect(c)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999109.altcon)
	e0:SetOperation(c999109.altop)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999109,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,999109)
	e1:SetCost(c999109.drcost)
	e1:SetTarget(c999109.drtg)
	e1:SetOperation(c999109.drop)
	c:RegisterEffect(e1)
	--to hand
	local e25=Effect.CreateEffect(c)
	e25:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e25:SetType(EFFECT_TYPE_IGNITION)
	e25:SetRange(LOCATION_MZONE)
	e25:SetTarget(c999109.opttg)
	e25:SetOperation(c999109.optop)
	c:RegisterEffect(e25)
end
function c999109.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999109.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999109.opttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,750)
end
function c999109.optop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.Recover(tp,750,REASON_EFFECT)
	end
end
function c999109.cfilter(c)
	return (c:IsSetCard(0xaedf) or c:IsSetCard(0xabdf)) and c:IsDiscardable()
end
function c999109.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c999109.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c999109.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c999109.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c999109.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end