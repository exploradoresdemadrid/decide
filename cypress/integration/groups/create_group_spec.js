/// <reference types="cypress" />

context('Group creation', () => {
  const uuid = () => Cypress._.random(0, 1e6)
  let currentUUID
  let groupName

  before(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.loginAsAdmin()
  })
  beforeEach(() => {
    currentUUID = uuid()
    groupName = 'Sample name ' + currentUUID
    Cypress.Cookies.preserveOnce('_decide_session')
    cy.fillGroupForm(groupName)
  })

  it('create and delete group', () => {
    cy.contains('Submit').click()
    cy.get('.alert.alert-info').should('contain', 'Group was successfully created.')
    cy.percySnapshot();

    cy.get('#groups_index').contains('td', groupName).parent().contains('Destroy').click()
    cy.get('.alert.alert-info').should('contain', 'Group was successfully destroyed.')
    cy.percySnapshot();
  })

  it('return an error when name is missing', () => {
    cy.get('#group_name').clear()
    cy.contains('Submit').click()

    cy.get('span').should('contain', 'can\'t be blank')
    cy.percySnapshot();
  })

  it('return an error when available votes is 0', () => {
    cy.get('#group_available_votes').clear().type('0')
    cy.contains('Submit').click()

    cy.get('span').should('contain', 'must be greater than or equal to 1')
    cy.percySnapshot();
  })
})
