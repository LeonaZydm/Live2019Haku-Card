--Angelic Slate Warrior
function c999120.initial_effect(c)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999120.altcon)
	e0:SetOperation(c999120.altop)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999120,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,999120)
	e1:SetCost(c999120.thcost)
	e1:SetTarget(c999120.thtg)
	e1:SetOperation(c999120.thop)
	c:RegisterEffect(e1)
	--to hand
	local e25=Effect.CreateEffect(c)
	e25:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e25:SetType(EFFECT_TYPE_IGNITION)
	e25:SetRange(LOCATION_MZONE)
	e25:SetTarget(c999120.opttg)
	e25:SetOperation(c999120.optop)
	c:RegisterEffect(e25)
end
function c999120.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999120.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999120.opttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,675)
end
function c999120.optop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.Recover(tp,675,REASON_EFFECT)
	end
end
function c999120.cfilter(c)
	return c:IsSetCard(0xaedf) and c:GetDefense()==0 and not c:IsCode(999120) and c:IsAbleToRemoveAsCost()
end
function c999120.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c999120.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c999120.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c999120.filter(c,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	return c:IsType(TYPE_CONTINUOUS) and (not condition or condition(te,tp,eg,ep,ev,re,r,rp)) 
		and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0))
		and (not target or target(te,tp,eg,ep,ev,re,r,rp,0))
end
function c999120.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ct=ct+1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ct
		and Duel.IsExistingMatchingCard(c999120.filter,tp,LOCATION_GRAVE,0,1,nil,tp,eg,ep,ev,re,r,rp) end
end
function c999120.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local sg=Duel.GetMatchingGroup(c999120.filter,tp,LOCATION_GRAVE,0,nil,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local g=sg:Select(tp,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
        local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		if te then
    	    local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			Duel.ClearTargetCard()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if bit.band(tpe,TYPE_FIELD)~=0 then
				local of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
				tc:CancelToGrave(false)
			end
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			Duel.BreakEffect()
			if op then op(te,tp,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(te)
			if etc then	
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
		end
	end
end
