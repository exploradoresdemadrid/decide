/// <reference types="cypress" />

context('Reset authentication token', () => {
  before(() => {
    cy.clearCookies()
  })


  beforeEach(() => {
    cy.visit('http://localhost:3000/users/sign_in')
    cy.loginAsAdmin()
  })

  afterEach(() => {
    cy.logout()
  })

  it('modifies the authentication token for groups in the same organization', () => {
    cy.visit('http://localhost:3000/groups')
    cy.get('table').contains('td', 'Group 1').siblings(':nth-of-type(4)').first().invoke('text').then((oldAuthToken) => {
      cy.get('input').contains('Reset Tokens').click();
      cy.get('table').contains('td', 'Group 1').siblings(':nth-of-type(4)').first().invoke('text').then((newAuthToken) => {
        cy.get('table').contains('td', 'Group 1').siblings(':nth-of-type(4)').should('not.contain', oldAuthToken)
      })
    })
  })

  it('does not modify the authentication token for groups in other organization', () => {
    cy.visit('http://localhost:3000/groups')
    cy.get('table').contains('td', 'Group 1').siblings(':nth-of-type(4)').first().invoke('text').then((oldAuthToken) => {
      cy.logout();
      cy.loginAsSecondAdmin();
      cy.visit('http://localhost:3000/groups')
      cy.get('input').contains('Reset Tokens').click();
      cy.logout();
      cy.loginAsAdmin();
      cy.visit('http://localhost:3000/groups')
      cy.get('table').contains('td', 'Group 1').siblings(':nth-of-type(4)').should('contain', oldAuthToken)
    })
  })
})
