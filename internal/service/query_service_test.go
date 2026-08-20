package service

import (
	"context"
	"errors"
	"testing"

	"github.com/benbjohnson/clock"

	"watersafety/internal/domain"
	"watersafety/internal/store"
)

type detailFailureStore struct {
	store.Store
	item *domain.RiskCase
	err  error
}

func (s detailFailureStore) GetItem(context.Context, string) (*domain.RiskCase, error) {
	return s.item, nil
}

func (s detailFailureStore) GetAssignments(context.Context, string) ([]*domain.Referral, error) {
	return nil, s.err
}

func TestGetItemDetailPreservesRelatedReadErrors(t *testing.T) {
	sentinel := errors.New("assignment index unavailable")
	svc := NewQueryService(detailFailureStore{
		item: &domain.RiskCase{ID: "case-1"},
		err:  sentinel,
	}, clock.NewMock())

	_, err := svc.GetItemDetail(context.Background(), "case-1")
	if !errors.Is(err, sentinel) {
		t.Fatalf("expected related read error, got %v", err)
	}
}
